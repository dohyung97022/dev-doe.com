class Runtime {
    runtime: string
    version: string

    constructor(param: Partial<Runtime>) {
        this.runtime = param.runtime ?? ''
        this.version = param.version ?? ''
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
