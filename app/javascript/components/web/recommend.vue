<template>
  <div>
    <read-dialog
        :recommend_list="recommend_list"
        :read_visible="read_visible"
        :current_article="current_read"
        @close-dialog="read_visible = false"
    ></read-dialog>

    <div class="recommend animate__animated" :class="{animate__fadeInBottomRight: visible, animate__bounceOutRight: !visible}">
      <div class="recommend-wrap-header">
        <div>
          <h3>相关内容</h3>
        </div>

        <div @click="close">收起 ></div>
      </div>

      <div class="recommend-wrap">
        <div class="recommend-list">
          <div v-for="i in recommend_list"
               @click="read(i)"
               class="recommend-item">

            <h6>[{{ i.rss }}]{{ i.title }}</h6>
            <p>
              <a-tag
                  v-for="tag in i.tags"
                  :color="tag.recommend? 'green':''">
                <a-tooltip>
                  <template slot="title">
                    <template v-if="tag.recommend">
                      你曾收藏过相关标签内容
                    </template>
                    <template v-else>
                      文章相关标签
                    </template>
                  </template>
                  {{ tag.name + tag.tf_idf }}
                </a-tooltip>
              </a-tag>
            </p>
            <p>
              <time :datetime="i.pub_date" class="el-tooltip item">{{ i.pub_date }}</time>
            </p>

          </div>

          <div class="tip" v-if="recommend_list==null || recommend_list.length==0">
            <span>此文章暂无相关内容</span>
          </div>
        </div>
      </div>
    </div>

    <div
        v-if="!visible"
        class="fixed-button"
        @click="open">
      < 展开相关内容
    </div>
  </div>
</template>

<script>
import ReadDialog from "./read_dialog";

export default {
  props: ['recommend_list', 'visible'],
  data: function () {
    return {
      read_visible: false,
      current_read: null
    }
  },
  methods: {
    read: function (i) {
      this.read_visible = true;
      this.current_read = i
    },
    close: function () {
      this.$emit('close')
    },
    open: function () {
      this.$emit('open')
    }
  },
  components: {
    "read-dialog": ReadDialog
  },
};
</script>

<style scoped>
.recommend {
  position: absolute;
  /*animation: slidein 1s ease-in .2s;*/
  /*animation-fill-mode: forwards;*/
  /*width: 0px;*/
  /*height: 0px;*/
  width: 600px;
  height: 300px;
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  align-items: center;
  right: 16px;
  bottom: 60px;
  overflow: auto;
  border-radius: 15px;
  box-shadow: 5px 2px 25px #41b883;
  background-color: rgba(253, 253, 253, .95);
  padding: 8px;
}

/*@keyframes slidein {*/
/*  from {*/
/*    width: 0px;*/
/*    height: 0px;*/
/*  }*/
/*  to {*/
/*    width: 600px;*/
/*    height: 300px;*/
/*  }*/
/*}*/

.recommend-wrap-header {
  display: flex;
  width: 100%;
  flex-direction: row;
  justify-content: space-between;
  align-items: flex-start;
}

.recommend-wrap {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: flex-start;
  width: 100%;
}

.recommend-list {
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  align-items: center;
  width: 100%;
}

.recommend-item {
  width: 100%;
  height: 30%;
  margin: 8px 0;
  padding: 8px;
  background-color: rgba(255, 255, 25, .95);
  border-radius: 15px;
  box-shadow: 1px 1px 1px #fefefe;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  cursor: pointer;
}

.tip {
  color: #2E2F30;
  line-height: 120%;
}

.fixed-button {
  position: fixed;
  right: 16px;
  bottom: 60px;
  background-color: rgba(255, 255, 25, .5);
  border-radius: 15px;
  box-shadow: 1px 1px 1px #fefefe;
  padding: 4px;
}
</style>
