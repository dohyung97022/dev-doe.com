<template>
  <!-- 제목, 테스트, 저장 -->
  <div class="row" v-if="lambda != undefined">
    <h3 class="col-9 ps-sm-4 m-auto">{{ lambda.title }}</h3>
    <div class="col-3 d-flex flex-nowrap justify-content-end">
      <button class="btn-primary btn me-3" v-on:click="testLambda">test</button>
      <button class="btn-primary btn me-sm-4">
        <font-awesome-icon class="fa-solid" icon="floppy-disk" v-on:click="saveLambda"/>
      </button>
    </div>
  </div>
  <hr class="mb-0">
  <!-- code editor -->
  <div style="height: 40vh" class="p-sm-4" id="editor"></div>
  <!-- runtime 수정 -->
  <div class="btn-group row w-100 m-auto ps-sm-3 pe-sm-3 pt-3" role="group">
    <div class="btn btn-outline-secondary disabled col-3">Runtime</div>
    <button class="btn btn-primary dropdown-toggle col-9" type="button" id="runtimeDropdown" data-bs-toggle="dropdown">
      {{ this.lambda?.runtime }} {{ this.lambda?.version }}
    </button>
    <ul class="dropdown-menu" aria-labelledby="runtimeDropdown">
      <li v-for="runtime in this.runtimes" v-bind:key="runtime.runtime+runtime.version">
        <a class="dropdown-item" v-on:click="this.lambda?.set({runtime: runtime.runtime, version: runtime.version})">
          {{ runtime.runtime }} {{ runtime.version }}
        </a>
      </li>
    </ul>
  </div>
  <!-- endpoint -->
  <div class="btn-group row w-100 m-auto ps-sm-3 pe-sm-3 pt-3" role="group">
    <div class="btn btn-outline-secondary disabled col-3">Endpoint</div>
    <a class="btn btn-outline-secondary col-9" :href="this.lambda?.endpoint" target="_blank">
      {{ this.lambda?.endpoint }}
    </a>
  </div>
</template>

<script lang="ts">
import {defineComponent} from "vue";
import Lambda from "@/domain/lambda/model/Lambda";
import {basicSetup, EditorView} from "codemirror"
import {Compartment} from "@codemirror/state"
import {javascript} from "@codemirror/lang-javascript"
import {python} from "@codemirror/lang-python"
import {go} from "@codemirror/lang-go"
import Runtime from "@/domain/lambda/model/Runtime";
import runtime from "@/domain/lambda/model/Runtime";

export default defineComponent({
  name: "LambdaInfo",
  computed: {
    runtime() {
      return runtime
    }
  },

  data() {
    return {
      lambda: undefined as Lambda | undefined,
      editor: undefined as EditorView | undefined,
      compartment: new Compartment() as Compartment,
      runtimes: new Array<Runtime>() as Array<Runtime>,
    }
  },

  mounted() {
    this.createEditor();
    this.setEditorStyle();
    this.reqLambda();
    this.reqRuntime();
  },

  watch: {
    'lambda.runtime'(newVal: string, oldVal: string) {
      if (newVal == undefined || newVal == oldVal) {
        return;
      }
      this.setEditorLanguage(newVal);
      this.setEditorCode('');
    }
  },

  methods: {
    createEditor() {
      const parent = document.getElementById('editor')
      if (!parent) {
        console.error("document.getElementById('editor') is not found.")
        return
      }
      this.editor = new EditorView({
        extensions: [basicSetup, this.compartment.of(python())],
        parent: parent,

      })
    },

    setEditorStyle() {
      const elements = document.getElementsByClassName('cm-editor')
      const editorElement = elements[0] as HTMLElement
      editorElement.style.height = "100%"
    },

    setEditorLanguage(runtime: string) {
      // TODO: refactoring
      let runtimeFunc;
      if (runtime == 'node') {
        runtimeFunc = javascript;
      } else if (runtime == 'python') {
        runtimeFunc = python;
      } else if (runtime == 'golang') {
        runtimeFunc = go;
      } else {
        console.error("parameter runtime did not match codemirror type.")
        return
      }
      this.editor?.dispatch({
        effects: this.compartment.reconfigure(runtimeFunc())
      });
    },

    setEditorCode(code: string) {
      this.editor?.dispatch({
        changes: {
          from: 0,
          to: this.editor.state.doc.length,
          insert: code
        }
      });
    },

    async reqLambda() {
      // TODO: 조회 api 연결
      this.lambda = new Lambda({
        title: "lambda for testing",
        id: "2lkyldi229354",
        runtime: "node",
        version: "1.5",
        endpoint: "https://api.doe-dev.com/2lkyldi229354",
        code: "",
      });
    },

    async reqRuntime() {
      // TODO: runtime api 조회
      this.runtimes.push(new Runtime({runtime:"golang", version: "1.22"}))
      this.runtimes.push(new Runtime({runtime:"node", version: "20"}))
      this.runtimes.push(new Runtime({runtime:"python", version: "3.12"}))
      return
    },

    testLambda() {
      // TODO: 테스트 api 연결
      return
    },

    saveLambda() {
      // TODO: 저장 api 연결
      return
    }
  },
})
</script>
