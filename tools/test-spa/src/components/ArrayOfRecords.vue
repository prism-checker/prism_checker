<template>
  <div class="records">
    <template v-for="record in records">
      <div class="record">{{ record }}</div>
    </template>
  </div>
</template>

<script>
export default {
  data() {
    return {
      records: ['Record1']
    }
  },
  mounted() {
    setTimeout(() => this.records.push('Record2'), 1000)
    setTimeout(() => this.records.push('Record3'), 2000)
    setTimeout(() => this.records.push('Record4'), 3000)
  }
}
</script>

<style scoped>
  .record {
    background-color: #f6f6f6;
    padding: 1rem 2rem 2rem 2rem;
    margin-bottom: 1rem;
  }
</style>
