pateco._settingSubColor =
  data:
    id: '#sub-color'
    template  : Templates['module.setting.setting-sub.sub-color']()
    currentActive: 0
    onFocus: true
    subtitleColor: 'white'
    subtitleSize: 'font-type-2'
    subtitleOpacity: '0.75'
    buttons: [
      white =
        title: 'account-subtitle-colorwhite'
        value: 'white'
        action: ()->
          pateco._settingSubColor.updateValueColor('white')
      lightgreen =
        title: 'account-subtitle-colorlightgreen'
        value: 'lightgreen'
        action: ()->
          pateco._settingSubColor.updateValueColor('lightGreen')
      blue =
        title: 'account-subtitle-colorblue'
        value: 'blue'
        action: ()->
          pateco._settingSubColor.updateValueColor('blue')
      green =
        title: 'account-subtitle-colorgreen'
        value: 'green'
        action: ()->
          pateco._settingSubColor.updateValueColor('green')
      yellow =
        title: 'account-subtitle-coloryellow'
        value: 'yellow'
        action: ()->
          pateco._settingSubColor.updateValueColor('yellow')
      purple =
        title: 'account-subtitle-colorpurple'
        value: 'purple'
        action: ()->
          pateco._settingSubColor.updateValueColor('purple')
      red =
        title: 'account-subtitle-colorred'
        value: 'red'
        action: ()->
          pateco._settingSubColor.updateValueColor('red')
    ]
  
  initPage: ()->
    self = @
    # check Storage
    if localStorage.userSettings isnt null and localStorage.userSettings isnt undefined
        self.data.subtitleColor = JSON.parse(localStorage.userSettings).subtitleColor
        self.data.subtitleSize = JSON.parse(localStorage.userSettings).subtitleSize
        self.data.subtitleOpacity = JSON.parse(localStorage.userSettings).subtitleOpacity    
        self.render()
    self.initKey()
  

  render: ()->
    self = @
    source = self.data.template
    template = Handlebars.compile(source);
    $(self.data.id).html(template({
      onFocus: self.data.onFocus, 
      currentActive: self.data.currentActive, 
      buttons: self.data.buttons, 
      subtitleColor: self.data.subtitleColor
      subtitleSize: self.data.subtitleSize
      subtitleOpacity: self.data.subtitleOpacity
    }))

  toggleActiveMenu: (toggle)->
    listElement = '.btn-sub-color'
    unless toggle
      $(listElement).find('li').removeClass('active')
    else
      $(listElement).find('li').first().addClass('active')

  handleBackbutton: (keyCode, key) ->
    self = pateco._settingSubColor
    switch keyCode
      when key.DOWN
        self.data.currentActive = 0
        self.toggleActiveMenu(true)
        # check to focus Active Key handle
        self.initKey()
      when key.RETURN,key.ENTER
        self.data.haveSource = false
        self.data.currentActive = 0
        self.removePage()
        pateco._settingSub.initPage()

  handleKey: (keyCode, key)->
    self = pateco._settingSubColor
    console.info 'Setting Sub Color:' + keyCode
    listElement = '.btn-sub-color'
    length = $('.btn-sub-color').find('li').length
    # load detail notify in right panel
    actionKey = ()->
      self.data.currentActive = pateco.KeyService.reCalc(self.data.currentActive, length)
      pateco.UtitService.updateActive(listElement, self.data.currentActive, 'li')
    switch keyCode
      when key.ENTER
        pateco.UtitService.convertObjToArr(self.data.buttons)[self.data.currentActive].action()
        break;
      when key.RETURN
        console.log 'Call back to setting menu'
        self.data.haveSource = false
        self.removePage()
        pateco._settingSub.initPage()
        break;
      when key.UP
        self.data.currentActive--
        if self.data.currentActive < 0
          pateco._backButton.setActive(true, self.handleBackbutton)
          self.toggleActiveMenu(false)
        else
          actionKey()
        break;
      when key.DOWN
        self.data.currentActive++
        actionKey()
        break;
  initKey: ()->
    self = @
    pateco.KeyService.initKey(self.handleKey)
  
  removePage: ()->
    self = @
    $(self.data.id).find('.sub-color').removeClass('fadeIn').addClass('fadeOut')
    setTimeout(()->
      $(self.data.id).html('')
    , 500)
  
  # update color when press enter key
  updateValueColor: (color)->
    self = @
    self.data.subtitleColor = color
    pateco.UserService.upDateLocalStorage('userSettings','subtitleColor', color)
    pateco._settingSubColor.render()