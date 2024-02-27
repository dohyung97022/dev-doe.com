<template>
  <div class="mb-5 mt-4">
    <div v-for="lambda in lambdas" v-bind:key="lambda.hash">
      <div>{{ lambda.title }}</div>
    </div>
    <hr>
  </div>
</template>

<script lang="ts">
import {defineComponent} from "vue";
import Lambda from "@/views/lambda/components/model/Lambda";

export default defineComponent({
  name: "LambdaList",

  props: {},

  data() {
    return {
      lambdas: [] as Array<Lambda>
    }
  },

  mounted() {
    this.requestLambdas();
  },

  methods: {
    async requestLambdas() {
      const response = await fetch('https://api.dev-doe.com/lambda/list');
      const data = await response.json();
      this.lambdas = data;
    }
  },
})
</script>

<style scoped>

</style>