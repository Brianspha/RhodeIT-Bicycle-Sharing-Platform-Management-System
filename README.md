# About


## System overview
- Initial plan
To add


## App Screenshots
1. Docking Stations View <br />
![Alt text](/screenshots/1.PNG)
2. Detailed Stations View 
    <br />
    ![Alt text](/screenshots/2.PNG)

Assuming you dont embark and vue installed globally if not please install embark using the following commands if you already do skip to [link] (#ps)
### Installing EmbarkJS and Vue Cli Globally
1. ``npm install --global windows-build-tools`` 
2. ``npm install -g git``
3. ``npm install node-gyp``
4. ``npm install -g embark``
5.   ``npm install -g @vue/cli``

## <a name="ps"></a> Project setup 
```
npm install
```

### Compiles and hot-reloads for development
```
npm run serve
```

### Compiles and minifies for production
```
npm run build
```

### Run your tests
```
npm run test
```

### Lints and fixes files
```
npm run lint
```

### Customize configuration
See [Configuration Reference](https://cli.vuejs.org/config/).

### Connecting to the POA Cluster

```
embark run RChain --nodashboard
```

### To run embark locally
``` embark run --nodashboard```

Ensure you have geth installed before running the above command if you dont have geth you can run the following command

``` embark simulator```

enure your in the same directory as the project