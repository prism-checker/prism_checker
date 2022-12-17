<template>
  <div
    :class="loading ? 'loading' : 'app'"
  >
    <template v-if="loading">
      <div>Loading...</div>
    </template>
    <template v-else>
      <Header v-if="config.showHeader"/>
      <img class="logo" src="./assets/logo.png" alt="logo"/>
      <h1>My Blog</h1>
      <div
        class="posts-holder"
        v-show="!config.invisiblePosts"
        v-if="config.posts"
      >
        <h2>Posts</h2>
        <template v-for="post in config.posts">
          <post
            :post-data="post"
            v-show="!post.invisible"
          />
        </template>
      </div>
    </template>
  </div>
</template>

<script>
import Post from './components/Post.vue'
import Header from './components/Header.vue'

export default {
  components: {Post, Header},
  data() {
    return {
      loading: true,
      configs: {
        default: {
          delay: 400,
          posts: [
            {
              title: 'Lorem ipsum',
              content: 'Lorem ipsum dolor sit amet',
              author: 'Consectetur',
              date: '2020-10-11 10:11:12',
              delay: 400,
              comments: [
                {
                  content: 'Quisque vitae condimentum odio',
                  author: 'Convallis',
                  date: '2020-10-11 10:15:23',
                  delay: 400
                },
                {
                  content: 'Cras faucibus ac velit non aliquet',
                  author: 'Tristique',
                  date: '2020-10-11 10:22:08',
                  delay: 600
                },
              ]
            },
            {
              title: 'Vestibulum ante',
              content: 'Ut eget justo erat',
              author: 'Fringilla',
              date: '2020-10-11 14:45:32',
              comments: [
              //   {
              //   content: 'Vivamus vitae auctor nisl',
              //   author: 'Nullam',
              //   date: '2020-10-11 10:31:55',
              //   // delay: 300
              // }
              ],
              delay: 700,
            }
          ]
        },

        'zero-posts': {
          delay: 300,
          posts: []
        },

        'no-posts': {
          delay: 300,
        },

        'invisible-posts': {
          // delay: 300,
          invisiblePosts: true,
          posts: [
            {
              title: 'Vestibulum ante',
              content: 'Ut eget justo erat',
              author: 'Fringilla',
              date: '2020-10-11 14:45:32',
              comments: [],
              delay: 0,
            }
          ]
        }
      }
    }
  },

  mounted() {
    setTimeout(() => this.loading = false, this.config.delay)
  },

  computed: {
    config() {
      const urlParams = new URLSearchParams(window.location.search)
      const configName = urlParams.get('config') || 'default'
      return this.configs[configName]
    }
  }
}

  // ["Lorem ipsum dolor sit amet, consectetur adipiscing elit",
  // "Ut eget justo erat",
  // "",
  // "",
  // "",
  // "Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos",
  // "Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Aenean id mauris vel diam convallis rhoncus in id est",
  // "In hac habitasse platea dictumst",
  // "Nullam eu tellus volutpat, auctor ex ac, posuere massa",
  // "Curabitur quis commodo mauris",
  // "Fusce fringilla dolor in quam rhoncus volutpat",
  // "Nulla commodo congue mi vel efficitur",
  // "Suspendisse potenti",
  // "Pellentesque lacus leo, feugiat at cursus in, facilisis sit amet velit",
  // "Mauris tincidunt tincidunt ipsum eget pulvinar",
  // "  convallis fringilla"]

</script>

<style scoped>
.app {
  max-width: 800px;
  margin: 0 auto;
  padding: 2rem;

  font-weight: normal;
}
h1 {
  /*margin-left: 2rem;*/
  /*padding-left: 2rem;*/
}

img.logo{
  border: 1px solid silver;
}
</style>
