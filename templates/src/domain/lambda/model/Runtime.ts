class Runtime {
    runtime: string
    version: string

    constructor(param: Partial<Runtime>) {
        this.runtime = param.runtime ?? ''
        this.version = param.version ?? ''
    }

    set(param: Partial<Runtime>) {
        Object.assign(this, param);
    }
}

export default Runtime
