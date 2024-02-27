<template>
  <div class="container-xxl">
    <ViewTitle title="List" sub-title="생성된 lambda 를 나열합니다"/>

  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';
import ViewTitle from "@/components/viewTitle/ViewTitle.vue";

export default defineComponent({
  name: 'LambdaListView',
  components: {
    ViewTitle,
  },
});
</script>
