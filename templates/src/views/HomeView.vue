<template>
  <div class="container-xxl">
    <ViewTitle title="집" sub-title="도형이의 아득한 집입니다. 편히 쉬다 가시죠."/>
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';
import ViewTitle from "@/components/viewTitle/ViewTitle.vue";

export default defineComponent({
  name: 'HomeView',
  components: {
    ViewTitle,
  },
});
</script>
