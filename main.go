package main

import (
	"bytes"
	"context"
)

func main() {
	ctx := context.Background()
	stdout := bytes.Buffer{}
	stderr := bytes.Buffer{}
	cmd := Command("helm", "version").WithStderr(&stderr).WithStdout(&stdout)
	err := cmd.Do(ctx)
	if err != nil {
		panic(err)
	}
	println("Helm version output, stdout:")
	println(stdout.String())
	println("Helm version output, stderr:")
	println(stderr.String())
}
