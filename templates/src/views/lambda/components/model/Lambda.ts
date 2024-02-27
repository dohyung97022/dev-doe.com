class Lambda {
    title: string
    hash: string
    runtime: string
    version: string

    constructor(
        title: string,
        hash: string,
        runtime: string,
        version: string,
    ) {
        this.title = title
        this.hash = hash
        this.runtime = runtime
        this.version = version
    }
}

export default Lambda
