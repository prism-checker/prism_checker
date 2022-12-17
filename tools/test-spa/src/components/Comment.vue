<template>
  <div
   :class="loading ? 'loading' : 'comment'"
  >
    <template v-if="loading">
      <div>Loading...</div>
    </template>
    <template v-else>
      <div class="comment__author-name">{{ commentData.author }}</div>
      <div class="comment__date-time">{{ commentData.date }}</div>
      <div class="comment__content">{{ commentData.content }}</div>
    </template>
  </div>
</template>

<script>
export default {
  props: {
    commentData: {
      type: Object,
      required: true
    },
  },
  data() {
    return {
      loading: true
    }
  },
  mounted() {
    setTimeout(() => this.loading = false, this.commentData.delay)
  }
}
</script>

<style scoped>
.comment,
.loading {
  background-color: white;
  padding: 1rem;
  margin-bottom: 1rem;
}
.comment__author-name,
.comment__date-time {
  display: inline-block;
  padding-right: 2rem;
}
.comment__content {
  padding-top: 1rem;
}
</style>
