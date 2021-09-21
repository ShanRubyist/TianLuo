<template v-for="name in name_list">
  <div>
    <div>{{name.name}}</div>

    <span>
      {{name.changed}}
      从{{name.from_when}}开始，{{name.has_last}}
    </span>
    <br />
  </div>
</template>

<script>
export default {
  props: ["name_list"]
};
</script>

<style scoped></style>
