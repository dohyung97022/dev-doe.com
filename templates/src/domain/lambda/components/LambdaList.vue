<template>
  <div class="mb-5 mt-4">
    <div class="row">
      <h5 class="col-3 m-auto">Title</h5>
      <h5 class="col-2 m-auto">Runtime</h5>
      <h5 class="col-2 m-auto">Version</h5>
      <h5 class="col-4 m-auto">Endpoint</h5>
      <div class="col-1 m-auto">
        <router-link class="btn btn-primary" to="/lambda/add"><font-awesome-icon class="fa-solid" icon="plus"/></router-link>
      </div>
    </div>
    <hr>
    <div v-for="lambda in lambdas" v-bind:key="lambda.id" class="row">
      <div class="col-3 m-auto fw-bold" v-on:click="navLambdaInfo(lambda)">{{ lambda.title }}</div>
      <div class="col-2 m-auto" v-on:click="navLambdaInfo(lambda)">{{ lambda.runtime }}</div>
      <div class="col-2 m-auto" v-on:click="navLambdaInfo(lambda)">{{ lambda.version }}</div>
      <a class="col-4 m-auto" :href="lambda.endpoint" target="_blank">{{ lambda.endpoint }}</a>
      <div class="col-1 m-auto">
        <button class="btn btn-primary" v-on:click="reqDeleteLambda(lambda)">
          <font-awesome-icon class="fa-solid" icon="trash"/>
        </button>
      </div>
      <hr class="mt-3">
    </div>
  </div>
</template>

<script lang="ts">
import {defineComponent} from "vue";
import Lambda from "@/domain/lambda/model/Lambda";
import router from "@/router/routes";

export default defineComponent({
  name: "LambdaList",

  props: {},

  data() {
    return {
      lambdas: [] as Array<Lambda>
    }
  },

  mounted() {
    this.reqLambdas();
  },

  methods: {
    async reqLambdas() {
      // TODO: 리스트 조회 api 호출
      const lambda = new Lambda({
        title: "lambda for testing",
        id: "2lkyldi229354",
        runtime: "golang",
        version: "1.5",
        endpoint: "https://api.doe-dev.com/2lkyldi229354"
      });
      this.lambdas.push(lambda);
    },

    reqDeleteLambda(lambda: Lambda) {
      // TODO: 삭제 api 호출
      return
    },

    navLambdaInfo(lambda: Lambda) {
      router.push("/lambda/info?id=" + lambda.id);
    }
  },
})
</script>

<style scoped>

</style>