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
      <li><a class="dropdown-item" v-on:click="this.lambda.set({runtime: 'golang', version: '1.22'})">golang 1.22</a>
      </li>
      <li><a class="dropdown-item" v-on:click="this.lambda.set({runtime: 'node', version: '20'})">node 20</a></li>
      <li><a class="dropdown-item" v-on:click="this.lambda.set({runtime: 'python', version: '3.12'})">python 3.12</a>
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

export default defineComponent({
  name: "LambdaAdd",

  data() {
    return {
      // TODO: default lambda 규격 api 연결
      lambda: new Lambda({runtime: "golang", version: "1.22"}) as Lambda,
    }
  },

  methods: {
    async creteLambda() {
      // TODO: 생성 api 연결
      return
    },

    async reqDefaultLambda() {
      // TODO: default lambda 규격 api 연결
      return
    }
  },
})
</script>
