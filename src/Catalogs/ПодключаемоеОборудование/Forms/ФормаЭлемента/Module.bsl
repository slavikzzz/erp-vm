#Область ОбработчикиСобытийФорм

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОтображатьДопЭлементы = НЕ ОбщегоНазначенияБПО.ЭтоМобильнаяПлатформа();
	
	ПравоДоступаСохранениеДанныхПользователя = ПравоДоступа("СохранениеДанныхПользователя", Метаданные);
	СозданиеНовогоЭлемента = Объект.Ссылка = Справочники.ПодключаемоеОборудование.ПустаяСсылка();
	
	// Защита от изменения уже созданного экземпляра устройства.
	Элементы.ДрайверОборудования.ТолькоПросмотр = НЕ СозданиеНовогоЭлемента;
	Элементы.ДрайверОборудования.КнопкаОткрытия = Не СозданиеНовогоЭлемента;
	Элементы.ТипОборудования.ТолькоПросмотр = НЕ СозданиеНовогоЭлемента;
	     
	ПроверкаПараметров = СозданиеНовогоЭлемента;
	
	Если ОтображатьДопЭлементы Тогда
		Элементы.РабочееМесто.Видимость = Объект.ТипПодключения = Перечисления.ТипыПодключенияОборудования.ЛокальноеПодключение;
		Элементы.ОграничениеДоступа.Видимость = Объект.ТипПодключения = Перечисления.ТипыПодключенияОборудования.ОбщийДоступ;
	Иначе
		Элементы.РабочееМесто.Видимость = Ложь;
		Элементы.ТипПодключения.Видимость = Ложь;
		Элементы.ОграничениеДоступа.Видимость = Ложь; 
		Элементы.ПерейтиНаСайтИнструкции.Видимость = Ложь;
	КонецЕсли;

	Если СозданиеНовогоЭлемента Тогда 
		Если ПустаяСтрока(Объект.РабочееМесто) 
			И Объект.ТипПодключения = Перечисления.ТипыПодключенияОборудования.ЛокальноеПодключение Тогда
			Объект.РабочееМесто = МенеджерОборудованияВызовСервера.РабочееМестоКлиента();
		КонецЕсли;
		Объект.УстройствоИспользуется = Истина;
	Иначе
		Если Объект.ПометкаУдаления Или Не Объект.УстройствоИспользуется Тогда
			Элементы.ПараметрыПодключения.Доступность = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если ОбщегоНазначенияБПО.ИспользуетсяРаспределеннаяФискализация() Тогда
		МодульРаспределеннаяФискализация = ОбщегоНазначенияБПО.ОбщийМодуль("РаспределеннаяФискализация");
		Элементы.АвтоматическаяФискализация.Видимость = МодульРаспределеннаяФискализация.ДоступноРаспределеннаяФискализация();
	Иначе
		Элементы.АвтоматическаяФискализация.Видимость = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначенияБПО.ЭтоМобильнаяПлатформа() Тогда
		ОбщегоНазначенияБПО.ПодготовитьЭлементУправления(Элементы.ТипПодключения);
		ОбщегоНазначенияБПО.ПодготовитьЭлементУправления(Элементы.ТипОборудования);
		ОбщегоНазначенияБПО.ПодготовитьЭлементУправления(Элементы.ДрайверОборудования);
		ОбщегоНазначенияБПО.ПодготовитьЭлементУправления(Элементы.Организация);
		ОбщегоНазначенияБПО.ПодготовитьЭлементУправления(Элементы.Наименование);
		ОбщегоНазначенияБПО.ПодготовитьЭлементУправления(Элементы.РабочееМесто);
		ОбщегоНазначенияБПО.ПодготовитьЭлементУправления(Элементы.СерийныйНомер);   
		ОбщегоНазначенияБПО.ПодготовитьЭлементУправления(Элементы.СпособФорматноЛогическогоКонтроля);                                           
		ОбщегоНазначенияБПО.ПодготовитьЭлементУправления(Элементы.ДопустимоеРасхождениеФорматноЛогическогоКонтроля);
	КонецЕсли;
	
	Если СозданиеНовогоЭлемента Тогда
		Элементы.ДрайверОборудования.РежимВыбораИзСписка = Истина;
		ЗаполнитьСписокДрайверов();
	КонецЕсли;

	ОбновитьИнтерфейсФормы();    
	
	МенеджерОборудованияВызовСервераПереопределяемый.ЭкземплярОборудованияПриСозданииНаСервере(Объект, ЭтотОбъект, Отказ, Параметры, СтандартнаяОбработка);
	УстановитьВидимостьОрганизацииНаСервере();   
	
	Если ОбщегоНазначенияБПО.ИспользуетсяЧекопечатающиеУстройства() Тогда
		МодульОборудованиеЧекопечатающиеУстройства = ОбщегоНазначенияБПО.ОбщийМодуль("ОборудованиеЧекопечатающиеУстройства");
		МодульОборудованиеЧекопечатающиеУстройства.ОбновитьПараметрыРегистрацииККТ(ПараметрыРегистрацииККТ, Объект.ПараметрыРегистрации);
	КонецЕсли;
	
	Если СозданиеНовогоЭлемента Тогда     
		Элементы.ФормаЗагрузитьССайтаИТС.Видимость = Ложь;
	Иначе                    
		ДрайверОборудованияСсылка = Объект.ДрайверОборудования;
		ДрайверОборудованияРеквизиты = ОбщегоНазначенияБПО.ЗначенияРеквизитовОбъекта(ДрайверОборудованияСсылка, "СпособПодключения, СнятСПоддержки");
		ДоступнаЗагрузкаССайтаИТС = ДрайверОборудованияРеквизиты.СпособПодключения = Перечисления.СпособПодключенияДрайвера.ИзИнформационнойБазы 
			И НЕ ДрайверОборудованияРеквизиты.СнятСПоддержки;
		Элементы.ФормаЗагрузитьССайтаИТС.Видимость = ДоступнаЗагрузкаССайтаИТС 
			И ОбщегоНазначенияБПО.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ПолучениеВнешнихКомпонент");
	КонецЕсли;
	
	Элементы.ФормаСообщениеВТехническуюПоддержку.Видимость = ОбщегоНазначенияБПО.ИспользуетсяСообщенияВСлужбуТехническойПоддержки()
			И ОбщегоНазначенияБПОСлужебныйВызовСервера.ЗаполненыДанныеАутентификацииПользователяИнтернетПоддержки();
	
	Элементы.ФормаОперацииСОборудованием.Видимость = 
		ОбщегоНазначенияБПО.ИспользуетсяПодсистемаЛогирования()
		И Не ОбщегоНазначенияБПО.ЭтоМобильнаяПлатформа();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияБПО.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКоманды = ОбщегоНазначенияБПО.ОбщийМодуль("ПодключаемыеКоманды");
		МодульПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	МенеджерОборудованияВызовСервераПереопределяемый.ЭкземплярОборудованияПриЧтенииНаСервере(ТекущийОбъект, ЭтотОбъект);
	
	// Вызов БСП
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияБПО.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиентСервер = ОбщегоНазначенияБПО.ОбщийМодуль("ПодключаемыеКомандыКлиентСервер");
		МодульПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	// Конец Вызов БСП
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ОбщегоНазначенияБПОКлиент.ИспользуетсяСообщенияВСлужбуТехническойПоддержки() Тогда
		МодульСообщенияВСлужбуТехническойПоддержкиБПОКлиент = ОбщегоНазначенияБПОКлиент.ОбщийМодуль("СообщенияВСлужбуТехническойПоддержкиБПОКлиент");
		Элементы.ФормаСообщениеВТехническуюПоддержку.Видимость 
			= МодульСообщенияВСлужбуТехническойПоддержкиБПОКлиент.ОтправлятьСообщенияВТехПоддержку();
	КонецЕсли;
		
	Элементы.ФормаЗагрузитьССайтаИТС.Доступность = 
		ЗначениеЗаполнено(Объект.ТипОборудования) И ЗначениеЗаполнено(Объект.ДрайверОборудования);
	
	МенеджерОборудованияКлиентПереопределяемый.ЭкземплярОборудованияПриОткрытии(Объект, ЭтаФорма, Отказ);
	
	// Вызов БСП
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияБПОКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияБПОКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	// Конец Вызов БСП
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Не Отказ И Модифицированность Тогда
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
	
	МенеджерОборудованияКлиентПереопределяемый.ЭкземплярОборудованияПередЗаписью(Объект, ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	МенеджерОборудованияВызовСервераПереопределяемый.ЭкземплярОборудованияПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи);
	ПараметрыЗаписи.Вставить("НовыйЭлементБПО", ТекущийОбъект.ЭтоНовый());
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	МенеджерОборудованияВызовСервераПереопределяемый.ЭкземплярОборудованияПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.НовыйЭлементБПО И ЗначениеЗаполнено(ТекущийОбъект.ДрайверОборудования) Тогда
		Если Не ОбщегоНазначенияБПО.РазделениеВключено() Тогда
			ДобавитьДрайверВСправочникВнешнихКомпонентИзМакета(ТекущийОбъект.ДрайверОборудования);
		КонецЕсли;
	КонецЕсли;
	ПараметрыЗаписи.Удалить("НовыйЭлементБПО");
	
	ПараметрыУстройства = МенеджерОборудования.ПараметрыУстройства(Объект.Ссылка);
	МенеджерОборудованияВызовСервераПереопределяемый.ЭкземплярОборудованияПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи);
	
	ДрайверОборудованияСсылка = Объект.ДрайверОборудования;
	ДрайверОборудованияРеквизиты = 
		ОбщегоНазначенияБПО.ЗначенияРеквизитовОбъекта(ДрайверОборудованияСсылка, "СпособПодключения, СнятСПоддержки");
	ДоступнаЗагрузкаССайтаИТС = 
		ДрайверОборудованияРеквизиты.СпособПодключения = Перечисления.СпособПодключенияДрайвера.ИзИнформационнойБазы 
		И НЕ ДрайверОборудованияРеквизиты.СнятСПоддержки;
	Элементы.ФормаЗагрузитьССайтаИТС.Видимость = 
		ДоступнаЗагрузкаССайтаИТС 
		И ОбщегоНазначенияБПО.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ПолучениеВнешнихКомпонент");
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	СозданиеНовогоЭлемента = Ложь;
	
	Элементы.ПараметрыПодключения.Видимость = НЕ СозданиеНовогоЭлемента;
	
	ОбновитьИнтерфейсФормы();
	
	МенеджерОборудованияКлиентПереопределяемый.ЭкземплярОборудованияПослеЗаписи(Объект, ЭтотОбъект, ПараметрыЗаписи);
	
	// Вызов БСП
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияБПОКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияБПОКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	// Конец Вызов БСП
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	МенеджерОборудованияВызовСервераПереопределяемый.ЭкземплярОборудованияОбработкаПроверкиЗаполненияНаСервере(Объект, ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Если Модифицированность Или СозданиеНовогоЭлемента Тогда
			Если Записать() Тогда
				ПроверкаПараметров = Ложь;
				Закрыть();
			Иначе
				Возврат;
			КонецЕсли;
		Иначе
			ПроверкаПараметров = Ложь;
			Закрыть();
		КонецЕсли;
		МенеджерОборудованияКлиент.ВыполнитьНастройкуОборудования(Объект.Ссылка);
	Иначе
		ПроверкаПараметров = Ложь;
		Закрыть();
	КонецЕсли;   
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Не Объект.Ссылка.Пустая() Тогда
		Если ПроверкаПараметров И Не ЗавершениеРаботы Тогда
			Отказ = Истина;
			Текст = НСтр("ru = 'Для использования устройства необходимо настроить параметры подключения.
			|Перейти к настройке параметров подключения?';
			|en = 'To use the device, set up connection parameters.
			|Go to connection parameter setup?'");
			Оповещение = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение",  ЭтотОбъект);
			ПоказатьВопрос(Оповещение, Текст, РежимДиалогаВопрос.ДаНет);
		КонецЕсли;
		
		МенеджерОборудованияКлиентПереопределяемый.ЭкземплярОборудованияПередЗакрытием(Объект, ЭтотОбъект, Отказ, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	МенеджерОборудованияКлиентПереопределяемый.ЭкземплярОборудованияОбработкаНавигационнойСсылки(Объект, ЭтотОбъект, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементов

&НаКлиенте
Процедура ТипОборудованияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	Если Объект.ТипОборудования <> ВыбранноеЗначение Тогда
		Объект.ТипОборудования = ВыбранноеЗначение;
		Модифицированность = Истина;
		ЗаполнитьСписокДрайверов();
		Элементы.ФормаЗагрузитьССайтаИТС.Доступность = Ложь;
	Иначе
		Элементы.ФормаЗагрузитьССайтаИТС.Доступность = ЗначениеЗаполнено(Объект.ДрайверОборудования);
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ОбновитьИнтерфейсФормы();
	
	МенеджерОборудованияКлиентПереопределяемый.ЭкземплярОборудованияТипОборудованияВыбор(Объект, ЭтотОбъект, ЭтотОбъект, Элемент, ВыбранноеЗначение);
	
	Если Элементы.Организация.Видимость <> ОрганизацияВидимость Тогда
		УстановитьВидимостьОрганизацииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДрайверОборудованияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ВыбранноеЗначение <> Объект.ДрайверОборудования Тогда
		Объект.Наименование = "'" + Строка(ВыбранноеЗначение) + "'"
						+ ?(ПустаяСтрока(Строка(Объект.РабочееМесто)),
							"",
							" " + НСтр("ru = 'на';
										|en = 'to'") + " " + Строка(Объект.РабочееМесто));
	КонецЕсли;
	Элементы.ФормаЗагрузитьССайтаИТС.Доступность = ЗначениеЗаполнено(ВыбранноеЗначение);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Асинх Процедура УстройствоИспользуетсяПриИзменении(Элемент)
	
	ВыбранноеОборудование = Объект.Ссылка;
	Если ВыбранноеОборудование.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.УстройствоИспользуется Тогда
		Возврат;
	КонецЕсли;

	ВыдаватьПредупреждение = Истина;
	ТекстПредупреждения = НСтр("ru = 'Оборудование %1 используется в приложении.
							   |Отключение может привести к некорректной работе с этим оборудованием.
							   |Продолжить выполнение операции?';
							   |en = 'The %1 peripheral is used in the application.
							   |Disabling it may lead to incorrect operation of this peripheral.
							   |Continue?'");
	ТекстПредупреждения = СтрШаблон(ТекстПредупреждения, ВыбранноеОборудование);
	
	ОпределитьВозможностьОтключенияОборудования(ВыбранноеОборудование, ВыдаватьПредупреждение, ТекстПредупреждения);
	
	Если ВыдаватьПредупреждение Тогда
		Если Ждать ВопросАсинх(ТекстПредупреждения, РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
			Объект.УстройствоИспользуется = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПараметрыПодключения(Команда)
	
	Если СозданиеНовогоЭлемента Или Модифицированность Тогда
		Если Записать() Тогда
			ПроверкаПараметров = Ложь;
			Закрыть();
		Иначе
			Возврат;
		КонецЕсли;
	Иначе
		ПроверкаПараметров = Ложь;
		Закрыть();
	КонецЕсли;
	
	Если Объект.ТипОборудования = ПредопределенноеЗначение("Перечисление.ТипыПодключаемогоОборудования.ОблачнаяККТ") Тогда
		МодульОблачныеКассы = ОбщегоНазначенияБПОКлиент.ОбщийМодуль("ОблачныеКассыКлиент");
		МодульОблачныеКассы.НастройкаПодключения(Объект.Ссылка);
	Иначе
		МенеджерОборудованияКлиент.ВыполнитьНастройкуОборудования(Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РегистрацияФискальногоНакопителя(Команда)
	
	ОперацияФискальногоНакопителя(1);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменениеПараметровРегистрацииФискальногоНакопителя(Команда)
	
	ОперацияФискальногоНакопителя(2);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытиеФискальногоНакопителя(Команда)
	
	ОперацияФискальногоНакопителя(3);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиНаСайтИнструкцииНажатие(Элемент)
	
	АдресЗагрузки = "https://its.1c.ru/db/metod81#browse:13:-1:2115:2511";
	ОткрытьНавигационнуюСсылку(АдресЗагрузки);
	
КонецПроцедуры

&НаКлиенте
Процедура СообщениеИнфоПисьмоОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	АдресЗагрузки = "https://its.1c.ru/bmk/envd_kkt";
	ОткрытьНавигационнуюСсылку(АдресЗагрузки);
	
КонецПроцедуры

&НаКлиенте
Процедура СообщениеВТехническуюПоддержку(Команда)
	
	Если СозданиеНовогоЭлемента Или Модифицированность Тогда
		Записать();
	КонецЕсли;
	
	ИдентификаторОборудования = Объект.Ссылка;
	Если МенеджерОборудованияВызовСервера.ДрайверПоставляетсяВКонфигурации(ИдентификаторОборудования) Тогда
		МодульСообщенияВСлужбуТехническойПоддержкиБПОКлиент = ОбщегоНазначенияБПОКлиент.ОбщийМодуль("СообщенияВСлужбуТехническойПоддержкиБПОКлиент");
		ПараметрыДляСообщения = МодульСообщенияВСлужбуТехническойПоддержкиБПОКлиент.ПараметрыОтправкиСообщенияОбОшибке();
		ПараметрыДляСообщения.ИдентификаторОборудования = ИдентификаторОборудования;
		ПараметрыДляСообщения.ТекстОшибки = НСтр("ru = 'Информация для тех.поддержки';
												|en = 'Information for support'");
		ОписаниеОповещения = Новый ОписаниеОповещения("СообщениеВТехническуюПоддержкуЗавершение", ЭтотОбъект);
		МодульСообщенияВСлужбуТехническойПоддержкиБПОКлиент.НачатьОтправкуСообщенияОбОшибке(ОписаниеОповещения, ПараметрыДляСообщения);
	Иначе              
		ТекстСообщения = НСтр("ru = 'Обратитесь, пожалуйста, за помощью к поставщику драйвера. ';
								|en = 'Обратитесь, пожалуйста, за помощью к поставщику драйвера. '");
		ПоказатьПредупреждение(, ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СообщениеВТехническуюПоддержкуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Не ПустаяСтрока(Результат.КодОшибки) Тогда
		ОбщегоНазначенияБПОКлиент.СообщитьПользователю(Результат.СообщениеОбОшибке);
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура ОперацииСОборудованием(Команда)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Отбор", Новый Структура("Оборудование", Объект.Ссылка));
	ОткрытьФорму("РегистрСведений.ОперацииСПодключаемымОборудованием.ФормаСписка", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьИнтерфейсФормы();
	
	ТипОборудованияККТ         = Объект.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ККТ;
	ТипОборудованияФР          = Объект.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ФискальныйРегистратор;
	ТипОборудованияПЧ          = Объект.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ПринтерЧеков;
	ТипОборудованияОблачнаяККТ = Объект.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ОблачнаяККТ;
	
	ОрганизацияВидимость = ТипОборудованияККТ Или ТипОборудованияФР Или ТипОборудованияПЧ Или ТипОборудованияОблачнаяККТ;
	
	Элементы.ФискальныеДанные.Видимость = ТипОборудованияККТ И НЕ СозданиеНовогоЭлемента;
	
	Если Элементы.ФискальныеДанные.Видимость Или Элементы.ОграничениеДоступа.Видимость Тогда
		Элементы.Закладки.ОтображениеСтраниц = ОтображениеСтраницФормы.ЗакладкиСверху       
	Иначе
		Элементы.Закладки.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	КонецЕсли;
	
	Элементы.Организация.Видимость = ОрганизацияВидимость; 
	
	Если Объект.ПометкаУдаления Или Не Объект.УстройствоИспользуется Тогда
		Элементы.ПараметрыПодключения.Доступность = Ложь;     
	Иначе
		Элементы.ПараметрыПодключения.Доступность = Истина;     
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацияФискальногоНакопителя_Завершение(РезультатВыполнения, Параметры) Экспорт
	
	ОчиститьСообщения();
	
	Если РезультатВыполнения.Результат Тогда
		ТекстСообщения = НСтр("ru = 'Операция завершена.';
								|en = 'Operation completed.'");
	Иначе
		ТекстСообщения = РезультатВыполнения.ОписаниеОшибки;
	КонецЕсли;
	
	ОбщегоНазначенияБПОКлиент.СообщитьПользователю(ТекстСообщения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацияФискальногоНакопителя_Продолжить(РезультатВыполнения, Параметры) Экспорт
	
	Если РезультатВыполнения <> Неопределено 
		И ТипЗнч(РезультатВыполнения) = Тип("Структура")
		И ОбщегоНазначенияБПОКлиент.ИспользуетсяЧекопечатающиеУстройства() Тогда
		
		ФискальноеУстройство = Объект.Ссылка;
		ОповещениеПриЗавершении = Новый ОписаниеОповещения("ОперацияФискальногоНакопителя_Завершение", ЭтотОбъект);
		МодульОборудованиеЧекопечатающиеУстройстваКлиент = ОбщегоНазначенияБПОКлиент.ОбщийМодуль("ОборудованиеЧекопечатающиеУстройстваКлиент");
		МодульОборудованиеЧекопечатающиеУстройстваКлиент.НачатьОперациюФНДляФискальногоУстройства(ОповещениеПриЗавершении,
			УникальныйИдентификатор, ФискальноеУстройство, РезультатВыполнения); 
			
	КонецЕсли;
	
	ЭтотОбъект.Прочитать();
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацияФискальногоНакопителя(ТипОперации)
	
#Если ВебКлиент Тогда
	ПоказатьПредупреждение(, НСтр("ru = 'Данный функционал доступен только в режиме тонкого и толстого клиента.';
									|en = 'This functionality is available only in the thin and thick client mode.'"));
	Возврат;
#КонецЕсли
	
	ФискальноеУстройство = Объект.Ссылка;
	Если Не ЗначениеЗаполнено(ФискальноеУстройство) Тогда
		Возврат;
	КонецЕсли;               
	
	МодульОборудованиеЧекопечатающиеУстройстваКлиент = 
		ОбщегоНазначенияБПОКлиент.ОбщийМодуль("ОборудованиеЧекопечатающиеУстройстваКлиент");
	ПараметрыОткрытия = 
		МодульОборудованиеЧекопечатающиеУстройстваКлиент.ПараметрыФормаНастройкиРегистрацииККТ();
	ПараметрыОткрытия.ФискальноеУстройство = ФискальноеУстройство;
	ПараметрыОткрытия.Организация = Объект.Организация;
	ПараметрыОткрытия.ТипОперации = ТипОперации; 
	
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ОперацияФискальногоНакопителя_Продолжить", ЭтотОбъект);
	МодульОборудованиеЧекопечатающиеУстройстваКлиент
		.ОткрытьФормуНастройкиРегистрацииККТ(ОповещениеПриЗавершении, ПараметрыОткрытия);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокДрайверов()
	
	Если ОбщегоНазначенияБПО.ИспользуютсяОблачныеККТ() Тогда
		ТипОборудованияОблачнаяККТ = Объект.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ОблачнаяККТ;
		
		Элементы.ДрайверОборудования.СписокВыбора.Очистить();
		Элементы.ДрайверОборудования.Видимость = НЕ ТипОборудованияОблачнаяККТ;
		
		// ++ Локализация
		Если ТипОборудованияОблачнаяККТ Тогда
			Если ЗначениеЗаполнено(Справочники.ДрайверыОборудования.ПредопределенныйЭлемент("Справочник.ДрайверыОборудования.ОбработчикОблачныхККТ")) Тогда
				Объект.ДрайверОборудования = ПредопределенноеЗначение("Справочник.ДрайверыОборудования.ОбработчикОблачныхККТ");
				Возврат;
			КонецЕсли;
		КонецЕсли;
		// -- Локализация
	КонецЕсли;
	
	ДрайвераОборудования = МенеджерОборудования.ДрайверыПоТипуОборудования(Объект.ТипОборудования);
	Для Каждого ДрайверОборудования Из ДрайвераОборудования Цикл
		Элементы.ДрайверОборудования.СписокВыбора.Добавить(ДрайверОборудования.Значение, ДрайверОборудования.Представление);
	КонецЦикла;
	
	Объект.ДрайверОборудования = ПредопределенноеЗначение("Справочник.ДрайверыОборудования.ПустаяСсылка");
	Объект.Наименование = "";
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНавигационнуюСсылку(НавигационнаяСсылка, Знач Оповещение = Неопределено)
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		// Особенность платформы: ПерейтиПоНавигационнойСсылке не доступен в толстом клиенте обычного приложения.
		ОповещениеПриЗавершении = Новый ОписаниеОповещения();
		НачатьЗапускПриложения(ОповещениеПриЗавершении, НавигационнаяСсылка); // АПК:534 передаются фиксированные строки
	#Иначе
		ПерейтиПоНавигационнойСсылке(НавигационнаяСсылка); // АПК:534 передаются фиксированные строки
	#КонецЕсли

КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьОрганизацииНаСервере()
	
	Элементы.Организация.Видимость = ОрганизацияВидимость;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьССайтаИТС(Команда)
	
	// Вставить содержимое обработчика.
	Если СозданиеНовогоЭлемента Или Модифицированность Тогда
		Записать();
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ЗагрузитьССайтаИТСЗавершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.УстановитьДрайверОборудования(Оповещение, Объект.ДрайверОборудования);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьССайтаИТСЗавершение(РезультатВыполнения, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыполнения.Результат Тогда
		Заголовок = НСтр("ru = 'Компонента загружена.';
						|en = 'Add-in is imported.'");
		Текст     = СтрШаблон(НСтр("ru = 'Компонента %1 успешно загружена и установлена.';
									|en = 'The %1 add-in is successfully imported and installed.'"),
						РезультатВыполнения.ИдентификаторУстройства);
	Иначе
		Заголовок = НСтр("ru = 'Ошибка загрузки компоненты.';
						|en = 'Add-in import error.'");
		Текст     = СтрШаблон(НСтр("ru = 'Компонента %1 не загружена, по причине:
						|%2.';
						|en = 'The %1 add-in is not imported. Reason:
						|%2.'"),
						РезультатВыполнения.ИдентификаторУстройства,
						РезультатВыполнения.ОписаниеОшибки);
	КонецЕсли;
	ПоказатьПредупреждение(,Текст,,Заголовок);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОпределитьВозможностьОтключенияОборудования(ПодключаемоеОборудование, ВыдаватьПредупреждение, ТекстПредупреждения)

	СтандартнаяОбработка = Истина;
	МенеджерОборудованияВызовСервераПереопределяемый.ОпределитьВозможностьОтключенияОборудования(
		ПодключаемоеОборудование, ВыдаватьПредупреждение, ТекстПредупреждения, СтандартнаяОбработка);
	Если СтандартнаяОбработка Тогда
		ВыдаватьПредупреждение = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ДобавитьДрайверВСправочникВнешнихКомпонентИзМакета(СсылкаНаДрайвер)
	
	Если Не ОбщегоНазначенияБПО.ПодсистемаСуществует("СтандартныеПодсистемы.ВнешниеКомпоненты") Тогда
		Возврат
	КонецЕсли;

	// ++ НеМобильноеПриложение
	
	РеквизитыДрайвера = ОбщегоНазначенияБПО.ЗначенияРеквизитовОбъекта(СсылкаНаДрайвер, 
		"ИдентификаторОбъекта, СпособПодключения, Наименование, ИмяПредопределенныхДанных, ИмяМакетаДрайвера, ВерсияДрайвера");
	Если РеквизитыДрайвера.СпособПодключения = Перечисления.СпособПодключенияДрайвера.ИзМакета Тогда
	
		МодульВнешниеКомпонентыСервер = ОбщегоНазначенияБПО.ОбщийМодуль("ВнешниеКомпонентыСервер");
		
		ЗагруженныеВнешниеКопоненты = МодульВнешниеКомпонентыСервер.ИспользуемыеКомпоненты("ДляОбновления");
		НайденнаяСтрока = ЗагруженныеВнешниеКопоненты.Найти(РеквизитыДрайвера.ИдентификаторОбъекта, "Идентификатор");
		Если НайденнаяСтрока = Неопределено Тогда
			
			МакетДоступен = Ложь;
			ИмяМакетаДрайвера = РеквизитыДрайвера.ИмяМакетаДрайвера;
			ИмяДрайвера = РеквизитыДрайвера.ИмяПредопределенныхДанных;
			МенеджерОборудования.ЗаполнитьДанныеМакетов(ИмяДрайвера, ИмяМакетаДрайвера, МакетДоступен, Неопределено);
			Если МакетДоступен Тогда
				
				ДанныеДляДобавления = МенеджерОборудования.НовыеДанныеДляДобавленияВСправочникВнешнихКомпонент();
				ДанныеДляДобавления.Идентификатор = РеквизитыДрайвера.ИдентификаторОбъекта;
				ДанныеДляДобавления.ИмяМакета = СтрЗаменить(ИмяМакетаДрайвера, "ОбщийМакет.", "");
				ДанныеДляДобавления.Наименование = РеквизитыДрайвера.Наименование;
				ДанныеДляДобавления.Версия = РеквизитыДрайвера.ВерсияДрайвера;
				
				СтандартнаяОбработка = Истина;
				МенеджерОборудованияВызовСервераПереопределяемый.ПриЗагрузкеДрайвераВСправочникВнешниеКомпонентыПриДобавленииОборудования(ДанныеДляДобавления, СтандартнаяОбработка);
				Если Не СтандартнаяОбработка Тогда
					Возврат;
				КонецЕсли;
				
				ДрайверыДляДобавления = Новый Массив();
				ДрайверыДляДобавления.Добавить(ДанныеДляДобавления);
				МенеджерОборудования.ДобавитьВСправочникВнешнихКомпонентИзМакетаСлужебный(ДрайверыДляДобавления);
				
			КонецЕсли;
		Иначе
			МенеджерОборудования.УстановитьСпособПодключенияДрайвера(СсылкаНаДрайвер, Перечисления.СпособПодключенияДрайвера.ИзИнформационнойБазы);
		КонецЕсли;
	КонецЕсли;
	
	// -- НеМобильноеПриложение
	
КонецПроцедуры

&НаКлиенте
Процедура ТипОборудованияНачалоВыбора(Элемент, ДанныеВыбора, ВыборДобавлением, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = Новый СписокЗначений();
	ЗаполнитьДоступныеТипыОборудования(ДанныеВыбора, Объект.ТипПодключения);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьДоступныеТипыОборудования(ДанныеВыбора, ТипПодключения)
	
	Если ТипПодключения = Перечисления.ТипыПодключенияОборудования.ОбщийДоступ Тогда
		ДоступныеТипыОборудования = МенеджерОборудования.ДоступныеТипыОбщедоступногоОборудования();
	Иначе
		ДоступныеТипыОборудования = МенеджерОборудования.ДоступныеТипыОборудования();
	КонецЕсли;
	Для Каждого Тип Из ДоступныеТипыОборудования Цикл
		ДанныеВыбора.Добавить(Тип);
	КонецЦикла;
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	
	// Вызов БСП
	Если ОбщегоНазначенияБПОКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияБПОКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
	КонецЕсли;
	// Конец Вызов БСП
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры)
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	
	// Вызов БСП
	Если ОбщегоНазначенияБПО.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКоманды = ОбщегоНазначенияБПО.ОбщийМодуль("ПодключаемыеКоманды");
		МодульПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
	КонецЕсли;
	// Конец Вызов БСП
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	
	// Вызов БСП
	Если ОбщегоНазначенияБПОКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиентСервер = ОбщегоНазначенияБПОКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиентСервер");
		МодульПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	КонецЕсли;
	// Конец Вызов БСП
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти