<template>
  <div>
    <my-header/>
    <!-- Make sure to add the <nuxt/> component when creating a layout to display the page component. -->
    <!-- https://nuxtjs.org/guide/views#layouts -->
    <nuxt/>
    <my-footer/>
  </div>
</template>

<script>
import MyHeader from '~/components/header.vue'
import MyFooter from '~/components/footer.vue'

export default {
  components: {
    MyHeader,
    MyFooter
  }
}
</script>

<style>
.title {
  color: #000;
  font-weight: 300;
  font-size: 2.5em;
  margin: 0;
}
</style>
