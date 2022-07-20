package main

import (
	"context"
	"log"
	"time"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/appconfig"
	"github.com/aws/aws-sdk-go/aws"
)

func main() {
	ctx := context.TODO()
	cfg, err := config.LoadDefaultConfig(ctx, config.WithRegion("eu-central-1"))
	if err != nil {
		log.Fatalf("unable to load SDK config, %v", err)
	}

	svc := appconfig.NewFromConfig(cfg)
	cfgInput := &appconfig.GetConfigurationInput{
		Application:   aws.String("my app config"),
		Environment:   aws.String("alpha"),
		ClientId:      aws.String("wwsbwff"),
		Configuration: aws.String("9zzdigt"),
	}

	for {
		output, err := svc.GetConfiguration(ctx, cfgInput)
		if err != nil {
			log.Fatalf("unable to get config: %q", err)
		}
		log.Printf("app config:\n%s\n", output.Content)
		time.Sleep(1 * time.Minute)
	}
}
