package main

import (
	"bytes"
	"context"
	"os/exec"
)

func main() {
	ctx := context.Background()
	cmd := exec.CommandContext(ctx, "helm", "version")
	stdout := bytes.Buffer{}
	cmd.Stdout = &stdout
	stderr := bytes.Buffer{}
	cmd.Stderr = &stderr
	err := cmd.Run()
	if err != nil {
		panic(err)
	}
	println("Helm version output, stdout:")
	println(stdout.String())
	println("Helm version output, stderr:")
	println(stderr.String())
}
