<template>
  <div v-if="current_good">
    <div>
      <span class="current_good-detail-main">{{current_good.name}}</span>
    </div>

    <div>
      商品ID:
      <span class="good-detail-label">{{current_good.spu_id}}</span>
      &nbsp;&nbsp;
      平台:
      <span class="good-detail-label">{{current_good.platform}}</span>
      &nbsp;&nbsp;
      商品销量:
      <span class="good-detail-label">{{current_good.sales_num}}</span>
      &nbsp;&nbsp;
      销售规格：
      <a-popover title="SKU">
        <template slot="content" v-for="sku in current_good.skus">
          <div>
            <span>{{sku.spec}}</span>
            <span>{{sku.normal_price}}</span>
            <span>{{sku.group_price}}</span>
          </div>
        </template>
        <span class="good-detail-label">所有销售规格</span>
      </a-popover>
    </div>

    <div>
      店铺名称:
      <span class="good-detail-label">
        <a v-bind:href="current_good.shop_url" target="_blank">{{current_good.shop_name}}</a>
      </span>
      &nbsp;&nbsp;
      商品数量:
      <span class="good-detail-label">{{current_good.current_goods_num}}</span>
      &nbsp;&nbsp;
      销售量:
      <span class="good-detail-label">{{current_good.shop_sales_num}}</span>
      &nbsp;&nbsp;
      物流评分:
      <span class="good-detail-label">{{current_good.logistics_score}}</span>
      &nbsp;&nbsp;
      描述评分:
      <span class="good-detail-label">{{current_good.desc_score}}</span>
      &nbsp;&nbsp;
      服务评分:
      <span class="good-detail-label">{{current_good.service_score}}</span>
      &nbsp;&nbsp;
    </div>
  </div>
</template>

<script>
export default {
  props: ["current_good"]
};
</script>

<style scoped></style>
