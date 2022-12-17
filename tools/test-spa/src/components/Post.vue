<template>
  <div
    :class="loading ? 'loading' : 'post'"
  >
    <template v-if="loading">
      <div>Loading...</div>
    </template>
    <template v-else>
      <h3>{{ postData.title }}</h3>
      <div class="post__date-time">{{ postData.date }}</div>
      <div class="post__content">{{ postData.content }}</div>
      <div class="comments-holder">
        <h4>Comments</h4>
        <template v-for="commentData in postData.comments">
          <comment :comment-data="commentData" />
        </template>
      </div>
    </template>
  </div>
</template>

<script>
import Comment from './Comment.vue'

export default {
  components: {Comment},
  props: {
    postData: {
      type: Object,
      required: true
    }
  },
  data() {
    return {
      loading: true
    }
  },
  mounted() {
    setTimeout(() => this.loading = false, this.postData.delay)
  }
}
</script>

<style scoped>
  .post {
    background-color: #f6f6f6;
    padding: 1rem 2rem 2rem 2rem;
    margin-bottom: 1rem;
  }

  h2,
  .post__date-time {
    display: inline-block;
    padding-right: 2rem;
  }

  h3 {
    margin-bottom: 0.4rem;
  }

  .post__date-time {
    font-size: 80%;
    margin-bottom: 1rem;
  }
</style>
