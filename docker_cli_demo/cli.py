import typer

app = typer.Typer()

@app.command()
def demo1(val: str = typer.Option("DEMO1", help="DEMO, Any String.")):
    from docker_cli_demo.lib.demo import Demo
    print("call demo1")
    demo = Demo(val)

@app.command()
def demo2(val: str = typer.Option("DEMO2", help="DEMO, Any String.")):
    from docker_cli_demo.lib.demo import Demo
    print("call demo2")
    demo = Demo(val)


if __name__ == "__main__":
    app()