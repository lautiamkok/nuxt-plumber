<template>
  <div class="row row-plot">

    <!-- grid-container -->
    <div class="grid-container">

      <!--grid-x -->
      <div class="grid-x grid-padding-x">
        <div class="medium-3 cell">

          <form v-on:submit.prevent="submitPlot" id="form-plot">

            <div>
              <label>Plot:
                <select name="plot" v-model="form.plot">
                  <option v-for="(plot, index) in plots" :key="index" :value="plot.value">
                    {{ plot.name }}
                  </option>
                </select>
              </label>
            </div>

            <div>
              <label>Species:
                <select name="species" v-model="form.species">
                  <option value="">All species</option>
                  <option v-for="(item, index) in species" :key="index" :value="item.value">
                    {{ item.name }}
                  </option>
                </select>
              </label>
            </div>

            <div v-if="form.plot === 'scatter'">
              <label>Measurements:
                <select name="measurement" v-model="form.measurement">
                  <option value="">Petal and sepal</option>
                  <option v-for="(measurement, index) in measurements" :key="index" :value="measurement.value">
                    {{ measurement.name }}
                  </option>
                </select>
              </label>
            </div>

            <div v-if="form.plot === 'histogram' || form.plot === 'density' ">
              <label>Measurements:
                <select name="measurement" v-model="form.measurement">
                  <option value="petal.width">Petal width</option>
                  <option value="petal.length">Petal length</option>
                  <option value="sepal.width">Sepal width</option>
                  <option value="sepal.length">Sepal length</option>
                </select>
              </label>
            </div>

            <div v-if="form.plot === 'facet'">
              <label>Facet grid options:
                <select name="grid" v-model="form.grid">
                  <option v-for="(grid, index) in grids" :key="index" :value="grid.value">
                    {{ grid.name }}
                  </option>
                </select>

              </label>
            </div>

            <button type="submit" class="button">Submit</button>
          </form>

          <no-ssr>
            <!-- this component will only be rendered on client-side -->
            <p><pre>params: {{ form }}</pre></p>
          </no-ssr>

          <div>

            <h1>{{ title }}</h1>
            <p>The iris dataset (included with R) contains four measurements for 150 flowers representing three species of iris (Iris setosa, versicolor and virginica). On this page there are photos of the three species, and some notes on classification based on sepal area versus petal area.</p>
          </div>

        </div>

        <div class="medium-9 cell">
          <img :src="image" />
        </div>

      </div>
      <!--grid-x -->

    </div>
    <!-- grid-container -->

  </div>
</template>

<script>
import axios from '~/plugins/axios'
import querystring from 'querystring'
import NoSSR from 'vue-no-ssr'

export default {
  // https://alligator.io/vuejs/hide-no-ssr/
  // https://github.com/egoist/vue-no-ssr
  components: {
    'no-ssr': NoSSR
  },
  async mounted () {
    // Initiate foundation.
    // Must do it after Vue has rendered the view.
    $(document).foundation()

    // Get Z Foundation media query screen size.
    // http://foundation.zurb.com/sites/docs/javascript-utilities.html#mediaquery
    function getZFcurrentMediaQuery () {
      return Foundation.MediaQuery.current
    }

    window.addEventListener('resize', () => {
      var current = getZFcurrentMediaQuery()
      console.log('Screen size: ' + current)
    })

    // https://stackoverflow.com/questions/10328665/how-to-detect-browser-minimize-and-maximize-state-in-javascript
    document.addEventListener('visibilitychange', () => {
      console.log(document.hidden, document.visibilityState)
    }, false)

    // Plot the data as soon as you are mounted.
    this.submitPlot()
  },
  async asyncData () {
    var props = {
      title: 'Iris (plant) Dataset',
      image: '',
      plots: [
        { name: 'Scatter', value: 'scatter'},
        { name: 'Histogram', value: 'histogram'},
        { name: 'Density', value: 'density'},
        { name: 'Facet', value: 'facet'}
      ],
      species: [
        { name: 'Setosa', value: 'setosa'},
        { name: 'Versicolor', value: 'versicolor'},
        { name: 'Virginica', value: 'virginica'}
      ],
      measurements: [
        { name: 'Petal only', value: 'petal'},
        { name: 'Sepal only', value: 'sepal'}
      ],
      // measurements: [
      //   { name: 'Petal width', value: 'petal.width'},
      //   { name: 'Petal length', value: 'petal.length'},
      //   { name: 'Sepal width', value: 'sepal.width'},
      //   { name: 'Sepal length', value: 'sepal.length'}
      // ],
      grids: [
        { name: 'Rows', value: 'rows'},
        { name: 'Columns', value: 'columns'}
      ],
      // Default selections.
      form: {
        plot: 'scatter',
        species: '',
        measurement: '',
        grid: 'rows'
      }
    }
    return props
  },
  methods: {
    async submitPlot() {
      // Serialize form.
      // https://stackoverflow.com/questions/11661187/form-serialize-javascript-no-framework
      let formData = Array.from(new FormData(document.getElementById('form-plot')).entries(),
           e => e.map(encodeURIComponent).join('=')).join('&')

      // https://012.vuejs.org/guide/forms.html
      let response = await axios({
        method: 'post',
        url: '/iris',

        // Stringify the object so you get: plot=scatter&species=setosa
        // https://github.com/axios/axios/issues/350#issuecomment-227270046
        data: querystring.stringify(this.form),

        headers: {
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        responseType: 'arraybuffer'
      })

      // Handle response image type.
      // https://github.com/axios/axios/issues/513
      var imageData = new Buffer(response.data, 'binary').toString('base64')

      // Update the image data.
      this.image = 'data:image/jpeg;base64, ' + imageData
    }
  },

  watch: {
    // https://stackoverflow.com/questions/42133894/vue-js-how-to-properly-watch-for-nested-properties
    'form.plot': function(val, oldVal){
      if (val === 'histogram') {
        this.form.measurement = 'petal.width'
      }
      if (val === 'density') {
        this.form.measurement = 'petal.width'
      }
      if (val === 'scatter') {
        this.form.measurement = ''
      }
    }
  },
  head () {
    return {
      title: 'Nuxt + R',
      meta: [
        { hid: 'description', name: 'description', content: 'Plot page' }
      ],
    }
  }
}
</script>

<style>
h1 {
  font-size: 25px;
}

p {
  font-size: 16px;
}
</style>
