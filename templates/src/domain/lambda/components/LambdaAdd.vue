<template>
  <!-- 제목 수정 -->
  <div class="input-group row w-100 m-auto ps-sm-3 pe-sm-3 pt-3" role="group">
    <div class="btn btn-outline-secondary disabled col-3">Title</div>
    <input type="text" class="form-control text-center" placeholder="Type your title here!!"
           v-model="this.lambda.title">
  </div>
  <!-- runtime 수정 -->
  <div class="btn-group row w-100 m-auto ps-sm-3 pe-sm-3 pt-3" role="group">
    <div class="btn btn-outline-secondary disabled col-3">Runtime</div>
    <button class="btn btn-primary dropdown-toggle col-9" type="button" id="runtimeDropdown" data-bs-toggle="dropdown">
      {{ this.lambda.runtime }} {{ this.lambda.version }}
    </button>
    <ul class="dropdown-menu" aria-labelledby="runtimeDropdown">
      <li v-for="runtime in this.runtimes" v-bind:key="runtime.runtime+runtime.version">
        <a class="dropdown-item" v-on:click="this.lambda?.set({runtime: runtime.runtime, version: runtime.version})">
          {{ runtime.runtime }} {{ runtime.version }}
        </a>
      </li>
    </ul>
  </div>
  <!-- 생성 -->
  <div class="w-100 row m-auto ps-sm-3 pe-sm-3 pt-3">
    <button class="btn btn-outline-secondary col" v-on:click="creteLambda">Create</button>
  </div>
</template>

<script lang="ts">
import {defineComponent} from "vue";
import Lambda from "@/domain/lambda/model/Lambda";
import axios from "axios";
import router from "@/router/routes";
import Runtime from "@/domain/lambda/model/Runtime";

export default defineComponent({
  name: "LambdaAdd",

  data() {
    return {
      lambda: new Lambda({}) as Lambda,
      runtimes: new Array<Runtime>() as Array<Runtime>,
      lambdaEndpoint: process.env.VUE_APP_LAMBDA_CLONE_API as string
    }
  },

  mounted() {
    this.reqDefaultLambda();
    this.reqRuntime();
  },

  methods: {
    async creteLambda() {
      if (this.lambda.title == "") {
        alert("Title 이 지정되지 않았습니다.");
        return;
      }
      axios.post(this.lambdaEndpoint + "/lambda", this.lambda)
          .then(res => {
            if (res.status != 200) {
              throw new Error(res.data);
            }
            router.push("/lambda/info?id=" + res.data);
            alert('저장되었습니다.');
          })
          .catch(error => {
            router.push("/lambda/about");
            alert('오류가 발생하였습니다.' + error);
            console.error(error);
          })
    },

    async reqDefaultLambda() {
      axios.get(this.lambdaEndpoint + "/lambda/default")
          .then(res => {
            if (res.status != 200) {
              throw new Error(res.data);
            }
            this.lambda = new Lambda(res.data);
            this.lambda.id = "";
          }).catch(error => {
            router.push("/lambda/about");
            alert("오류가 발생하였습니다." + error);
            console.error(error);
      })
      return
    },

    async reqRuntime() {
      axios.get(this.lambdaEndpoint + "/runtimes")
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
  },
})
</script>
