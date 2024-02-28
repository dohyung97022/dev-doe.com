<template>
  <div class="container-xxl">
    <ViewTitle title="Info" sub-title="lambda 를 조회합니다."/>
    <LambdaInfo/>
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';
import ViewTitle from "@/components/viewTitle/ViewTitle.vue";
import LambdaInfo from "@/domain/lambda/components/LambdaInfo.vue";

export default defineComponent({
  name: 'LambdaInfoView',
  components: {
    LambdaInfo,
    ViewTitle,
  },
});
</script>
