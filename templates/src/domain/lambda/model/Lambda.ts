class Lambda {
    title: string
    id: string
    runtime: string
    version: string
    endpoint: string
    code: string

    constructor(param: Partial<Lambda>) {
        this.title = param.title ?? ''
        this.id = param.id ?? ''
        this.runtime = param.runtime ?? ''
        this.version = param.version ?? ''
        this.endpoint = param.endpoint ?? ''
        this.code = param.code ?? ''
    }

    set(param: Partial<Lambda>) {
        Object.assign(this, param);
    }
}

export default Lambda
