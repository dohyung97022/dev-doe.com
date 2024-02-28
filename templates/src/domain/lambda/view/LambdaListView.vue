<template>
  <div class="container-xxl">
    <ViewTitle title="List" sub-title="생성된 lambda 를 나열합니다."/>
    <LambdaList/>
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';
import ViewTitle from "@/components/viewTitle/ViewTitle.vue";
import LambdaList from "@/domain/lambda/components/LambdaList.vue";

export default defineComponent({
  name: 'LambdaListView',
  components: {
    ViewTitle,
    LambdaList,
  },
});
</script>
