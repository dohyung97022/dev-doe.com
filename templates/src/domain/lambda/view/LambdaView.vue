<template>
  <div class="container-xxl">
    <ViewTitle title="AWSLambdaClone" sub-title="Kubernetes 의 이해를 위해 aws lambda 의 내부 시스템을 추정, 구성한 프로젝트."/>
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';
import ViewTitle from "@/components/viewTitle/ViewTitle.vue";

export default defineComponent({
  name: 'LambdaView',
  components: {
    ViewTitle,
  },
});
</script>
