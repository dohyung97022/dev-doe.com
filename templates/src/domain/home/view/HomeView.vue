<template>
  <div class="container-xxl">
    <ViewTitle title="Home" sub-title="Home sweet home. May you be in peace."/>
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
