<template>
  <div class="mb-5 mt-4">
    <div class="row">
      <h5 class="col-3 m-auto">Title</h5>
      <h5 class="col-2 m-auto">Runtime</h5>
      <h5 class="col-2 m-auto">Version</h5>
      <h5 class="col-4 m-auto">RegDate</h5>
      <div class="col-1 m-auto">
        <router-link class="btn btn-primary" to="/lambda/add">
          <font-awesome-icon class="fa-solid" icon="plus"/>
        </router-link>
      </div>
    </div>
    <hr>
    <div v-for="lambda in lambdas" v-bind:key="lambda.id" class="row">
      <div class="col-3 m-auto fw-bold text-truncate" v-on:click="navLambdaInfo(lambda)">{{ lambda.title }}</div>
      <div class="col-2 m-auto" v-on:click="navLambdaInfo(lambda)">{{ lambda.runtime }}</div>
      <div class="col-2 m-auto" v-on:click="navLambdaInfo(lambda)">{{ lambda.version }}</div>
      <a class="col-4 m-auto text-truncate" :href='lambdaEndpoint + "/lambda/endpoint/" + lambda.id' target="_blank">
        {{ lambdaEndpoint + "/lambda/endpoint/" + lambda.id }}
      </a>
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
import axios from "axios";

export default defineComponent({
  name: "LambdaList",

  props: {},

  data() {
    return {
      lambdas: [] as Array<Lambda>,
      lambdaEndpoint: process.env.VUE_APP_LAMBDA_CLONE_API as string
    }
  },

  mounted() {
    this.reqLambdas();
  },

  methods: {
    async reqLambdas() {
      axios.get(this.lambdaEndpoint + "/lambda/list")
          .then(res => {
            if (res.status != 200) {
              throw new Error(res.data);
            }
            this.lambdas = Lambda.getLambdas(res.data.lambdas);
          })
          .catch(error => {
            router.push("/lambda/about");
            alert('오류가 발생하였습니다.' + error);
            console.error(error);
          })
    },

    async reqDeleteLambda(lambda: Lambda) {
      axios.delete(this.lambdaEndpoint + "/lambda", {"params": {"id": lambda.id}})
          .then(res => {
            if (res.status != 200) {
              throw new Error(res.data);
            }
            router.go(0);
            alert("삭제되었습니다.");
          })
          .catch(error => {
            router.push("/lambda/about");
            alert('오류가 발생하였습니다.' + error);
            console.error(error);
          })
    },

    navLambdaInfo(lambda: Lambda) {
      router.push("/lambda/info?id=" + lambda.id);
    }
  },
})
</script>

<style scoped>

</style>