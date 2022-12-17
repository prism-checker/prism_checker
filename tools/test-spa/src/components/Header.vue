<template>
  <div class="header">
    <div>
      <img class="logo" src="../assets/logo.png" alt="logo"/>
    </div>
    <div>
      <template v-if="loggedIn">
        <img class="avatar" src="../assets/avatar.png" alt="username">
        <button>Log out</button>
      </template>
      <template v-else>
        <input class="login" value="login">
        <input class="password" value="password" type="password">
        <button>Log in</button>
      </template>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    // commentData: {
    //   type: Object,
    //   required: true
    // },
  },
  data() {
    return {
      loggedIn: false
    }
  }
}
</script>

<style scoped>
.header {
  display: flex;
  justify-content: space-between;
}
input {
  width: 5rem;
  margin-right: 1rem;
}
</style>
