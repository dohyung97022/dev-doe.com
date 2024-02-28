<template>
  <div class="container-xxl">
    <ViewTitle title="Add" sub-title="lambda 를 생성합니다."/>
    <LambdaAdd/>
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';
import ViewTitle from "@/components/viewTitle/ViewTitle.vue";
import LambdaAdd from "@/domain/lambda/components/LambdaAdd.vue";

export default defineComponent({
  name: 'LambdaAddView',
  components: {
    ViewTitle,
    LambdaAdd,
  },
});
</script>
