<template>
  <a-modal v-model="visible"
           :footer="null"
           :closable="true"
           title="相关内容"
           centered width="90%">
    <div class="wrap">

    <!--Feed 列表区域-->
    <article-list name="read_ariticle-list"
                  :full_screen="false"
                  :rss_list_json="recommend_list"
                  :current_article="current_article"
                  @change_article="change_article"
    ></article-list>

    <!--    Feed 详情内容-->
    <article-detail name="read_ariticle-detail"
                    :full_screen="false"
                    :current_article="current_article"
                    :font_list="[]"
    >
    </article-detail>
    </div>

  </a-modal>
</template>

<script>
import ArticleList from "./article_list.vue";
import ArticleDetail from "./article_detail2.vue";

// dialog 组件
export default {
  components: {
    "article-list": ArticleList,
    "article-detail": ArticleDetail
  },
  props: ["read_visible", 'recommend_list', 'current_article'],
  data: function () {
    return {
    };
  },
  computed: {
    visible: {
      get: function() {
        return this.read_visible;
      },
      set: function(val) {
        this.$emit("close-dialog");
      }
    }
  },
  methods: {
    change_article: function (article) {
      this.current_article = article;
    },
  }
};
</script>

<style scoped>
.wrap {
  display: flex;

}

</style>
