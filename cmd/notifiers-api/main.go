// Copyright (c) Abstract Machines
// SPDX-License-Identifier: Apache-2.0

// Package main starts the HTTP API for notifiers subscriptions.
package main

import (
	"context"
	"fmt"
	"log"
	"os"

	"github.com/absmach/magistrala/consumers"
	"github.com/absmach/magistrala/consumers/notifiers"
	napi "github.com/absmach/magistrala/consumers/notifiers/api"
	npostgres "github.com/absmach/magistrala/consumers/notifiers/postgres"
	mglog "github.com/absmach/magistrala/logger"
	authnsvc "github.com/absmach/magistrala/pkg/authn/authsvc"
	"github.com/absmach/magistrala/pkg/grpcclient"
	"github.com/absmach/magistrala/pkg/messaging"
	"github.com/absmach/magistrala/pkg/postgres"
	"github.com/absmach/magistrala/pkg/prometheus"
	"github.com/absmach/magistrala/pkg/server"
	httpserver "github.com/absmach/magistrala/pkg/server/http"
	"github.com/absmach/magistrala/pkg/uuid"
	"github.com/caarlos0/env/v11"
	migrate "github.com/rubenv/sql-migrate"
	"golang.org/x/sync/errgroup"
)

const (
	svcName        = "notifiers-api"
	envPrefixDB    = "MG_NOTIFIERS_DB_"
	envPrefixHTTP  = "MG_NOTIFIERS_HTTP_"
	envPrefixAuth  = "MG_AUTH_GRPC_"
	defDB          = "repo"
	defSvcHTTPPort = "9014"
)

type config struct {
	LogLevel    string `env:"MG_NOTIFIERS_LOG_LEVEL"     envDefault:"info"`
	InstanceID  string `env:"MG_NOTIFIERS_INSTANCE_ID"   envDefault:""`
	FromAddress string `env:"MG_NOTIFIERS_FROM_ADDRESS"  envDefault:"noreply@greeniq.vn"`
}

type noopNotifier struct{}

var _ consumers.Notifier = (*noopNotifier)(nil)

func (noopNotifier) Notify(_ string, _ []string, _ *messaging.Message) error {
	return nil
}

func main() {
	ctx, cancel := context.WithCancel(context.Background())
	g, ctx := errgroup.WithContext(ctx)

	cfg := config{}
	if err := env.Parse(&cfg); err != nil {
		log.Fatalf("failed to load %s configuration : %s", svcName, err)
	}

	logger, err := mglog.New(os.Stdout, cfg.LogLevel)
	if err != nil {
		log.Fatalf("failed to init logger: %s", err.Error())
	}

	var exitCode int
	defer mglog.ExitWithError(&exitCode)

	if cfg.InstanceID == "" {
		if cfg.InstanceID, err = uuid.New().ID(); err != nil {
			logger.Error(fmt.Sprintf("failed to generate instanceID: %s", err))
			exitCode = 1
			return
		}
	}

	dbConfig := postgres.Config{Name: defDB}
	if err := env.ParseWithOptions(&dbConfig, env.Options{Prefix: envPrefixDB}); err != nil {
		logger.Error(err.Error())
		exitCode = 1
		return
	}

	db, err := postgres.Connect(dbConfig)
	if err != nil {
		logger.Error(err.Error())
		exitCode = 1
		return
	}
	defer db.Close()

	migrate.SetTable("notifiers_api_migrations")
	if _, err := migrate.Exec(db.DB, "postgres", *npostgres.Migration(), migrate.Up); err != nil {
		logger.Error(fmt.Sprintf("failed to apply migrations : %s", err))
		exitCode = 1
		return
	}

	grpcCfg := grpcclient.Config{}
	if err := env.ParseWithOptions(&grpcCfg, env.Options{Prefix: envPrefixAuth}); err != nil {
		logger.Error(fmt.Sprintf("failed to load auth gRPC configuration : %s", err))
		exitCode = 1
		return
	}

	authn, authnClient, err := authnsvc.NewAuthentication(ctx, grpcCfg)
	if err != nil {
		logger.Error(err.Error())
		exitCode = 1
		return
	}
	defer authnClient.Close()
	logger.Info("AuthN successfully connected to auth gRPC server " + authnClient.Secure())

	svc := notifiers.New(authn, npostgres.New(db), uuid.New(), noopNotifier{}, cfg.FromAddress)
	svc = napi.LoggingMiddleware(svc, logger)
	counter, latency := prometheus.MakeMetrics("notifiers", "api")
	svc = napi.MetricsMiddleware(svc, counter, latency)

	httpServerConfig := server.Config{Host: "0.0.0.0", Port: defSvcHTTPPort}
	if err := env.ParseWithOptions(&httpServerConfig, env.Options{Prefix: envPrefixHTTP}); err != nil {
		logger.Error(fmt.Sprintf("failed to load %s HTTP server configuration : %s", svcName, err))
		exitCode = 1
		return
	}

	hs := httpserver.NewServer(ctx, cancel, svcName, httpServerConfig, napi.MakeHandler(svc, logger, cfg.InstanceID), logger)

	g.Go(func() error {
		return hs.Start()
	})
	g.Go(func() error {
		return server.StopSignalHandler(ctx, cancel, logger, svcName, hs)
	})

	if err := g.Wait(); err != nil {
		logger.Error(fmt.Sprintf("%s service terminated: %s", svcName, err))
	}
}
