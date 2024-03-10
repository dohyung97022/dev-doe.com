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
      {{ this.editorRuntime.runtime }} {{ this.editorRuntime.version }}
    </button>
    <ul class="dropdown-menu" aria-labelledby="runtimeDropdown">
      <li v-for="runtime in this.runtimes" v-bind:key="runtime.runtime+runtime.version">
        <a class="dropdown-item" v-on:click="this.editorRuntime.set({runtime: runtime.runtime, version: runtime.version})">
          {{ runtime.runtime }} {{ runtime.version }}
        </a>
      </li>
    </ul>
  </div>
  <!-- endpoint -->
  <div class="btn-group row w-100 m-auto ps-sm-3 pe-sm-3 pt-3" role="group">
    <div class="btn btn-outline-secondary disabled col-3">Endpoint</div>
    <a class="btn btn-outline-secondary col-9 text-truncate" :href="this.lambda?.endpoint" target="_blank">
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
import axios from "axios";
import router from "@/router/routes";

export default defineComponent({
  name: "LambdaInfo",

  data() {
    return {
      id: this.$route.query.id as string,
      lambda: undefined as Lambda | undefined,
      editor: undefined as EditorView | undefined,
      editorRuntime: new Runtime({}) as Runtime,
      compartment: new Compartment() as Compartment,
      runtimes: new Array<Runtime>() as Array<Runtime>,
      lambdaEndpoint: process.env.VUE_APP_LAMBDA_CLONE_API as string,
    }
  },

  mounted() {
    this.deleteEditor();
    this.createEditor();
    this.setEditorStyle();
    this.reqLambda();
    this.reqRuntime();
  },

  watch: {
    'editorRuntime.runtime'(newVal: string, oldVal: string) {
      if (this.lambda == undefined || newVal == undefined || newVal == oldVal) {
        return;
      }
      this.setEditorLanguage(newVal);
      if (this.editorRuntime.runtime == this.lambda.runtime &&
          this.editorRuntime.version == this.lambda.version) {
        this.setEditorCode(this.lambda.code);
      } else {
        this.setEditorCode('');
      }
    }
  },

  methods: {
    createEditor() {
      const parent = document.getElementById('editor');
      if (!parent) {
        console.error("document.getElementById('editor') is not found.");
        return;
      }
      this.editor = new EditorView({
        extensions: [basicSetup, this.compartment.of(python())],
        parent: parent,
      })
    },

    deleteEditor() {
      const elements = document.getElementsByClassName('cm-editor');
      for (const element of elements) {
        element.remove();
      }
    },

    setEditorStyle() {
      const elements = document.getElementsByClassName('cm-editor');
      const editorElement = elements[0] as HTMLElement;
      editorElement.style.height = "100%";
    },

    setEditorLanguage(runtime: string) {
      if (this.editor == undefined) {
        console.error("editor is not created.");
      } else if (runtime == 'node') {
        this.editor?.dispatch({effects: this.compartment.reconfigure(javascript())});
      } else if (runtime == 'python') {
        this.editor?.dispatch({effects: this.compartment.reconfigure(python())});
      } else if (runtime == 'golang') {
        this.editor?.dispatch({effects: this.compartment.reconfigure(go())});
      } else {
        console.error("parameter runtime did not match codemirror type.");
      }
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
      axios.get(this.lambdaEndpoint + "/lambda", {"params": {"id": this.id}})
          .then(res => {
            if (res.status != 200) {
              throw new Error(res.data);
            }
            this.lambda = new Lambda(res.data);
            this.lambda.endpoint = this.lambdaEndpoint + "/lambda/endpoint/" + this.lambda.id;
            this.setEditorCode(this.lambda.code);
            this.editorRuntime.set({runtime: this.lambda.runtime, version: this.lambda.version})
          })
          .catch(error => {
            router.push("/lambda/about");
            alert('오류가 발생하였습니다.' + error);
            console.error(error);
          })
    },

    async reqRuntime() {
      axios.get(this.lambdaEndpoint + "/lambda/runtimes")
          .then(res => {
            if (res.status != 200) {
              throw new Error(res.data);
            }
            this.runtimes = Runtime.getRuntimes(res.data.runtimes);
          })
          .catch(error => {
            router.push("/lambda/about");
            alert('오류가 발생하였습니다.' + error);
            console.error(error);
          })
    },

    testLambda() {
      // TODO: 테스트 api 연결
      return;
    },

    async saveLambda() {
      if (this.lambda == undefined) {
        alert('lambda 가 조회되지 않았습니다.');
        return
      } else if (this.editor?.state.doc == undefined || this.editor?.state.doc.toString() == "") {
        alert('code 가 없습니다.');
        return
      }
      this.lambda.runtime = this.editorRuntime.runtime
      this.lambda.version = this.editorRuntime.version
      this.lambda.code = this.editor?.state.doc.toString()
      axios.patch(this.lambdaEndpoint + "/lambda", this.lambda)
          .then(res => {
            if (res.status != 200) {
              throw new Error(res.data);
            }
            router.go(0);
            alert('저장되었습니다.');
          })
          .catch(error => {
            router.push("/lambda/about");
            alert('오류가 발생하였습니다.' + error);
            console.error(error);
          })
    }
  },
})
</script>
