class Runtime {
    runtime: string
    version: string
    default_code: string

    constructor(param: Partial<Runtime>) {
        this.runtime = param.runtime ?? ''
        this.version = param.version ?? ''
        this.default_code = param.default_code ?? ''
    }

    static getRuntimes(param: Array<Partial<Runtime>>) {
        const runtimes = Array<Runtime>()
        for (const partial of param) {
            runtimes.push(new Runtime(partial))
        }
        return runtimes
    }

    set(param: Partial<Runtime>) {
        Object.assign(this, param);
    }
}

export default Runtime
