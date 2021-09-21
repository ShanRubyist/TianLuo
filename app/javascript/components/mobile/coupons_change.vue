<template>
  <div>
    <template v-for="coupon_item in coupon_list">
      <template v-for="coupon in coupon_item.coupons">
        <a-tag color="#f50">{{coupon}}</a-tag>
      </template>
      {{coupon_item.changed}}
      从{{coupon_item.from_when}}开始，{{coupon_item.has_last}}
    </template>
  </div>
</template>

  </div>
  
</template>

<script>
export default {
  props: ["coupon_list"]
};
</script>

<style scoped></style>
