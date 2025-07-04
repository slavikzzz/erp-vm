&НаКлиенте
Перем КонтекстЭДОКлиент;

&НаКлиенте
Перем ВыполняемоеОповещение;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Заявление = Параметры.Заявление;
	
	ИнициализироватьЗначения();
	УправлениеФормойПриСоздании();
	
	ЗапомнитьКлючПоложенияОкна();

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = НСтр("ru = 'Упрощенное заявление. Успешное создание закрытого ключа';
							|en = 'Упрощенное заявление. Успешное создание закрытого ключа'") Тогда
		ПоказатьСтраницуОтправкиЗаявления();
		ЗапретитьЗакрытие = Ложь;
	ИначеЕсли ИмяСобытия = НСтр("ru = 'Упрощенное заявление. Ошибка создание закрытого ключа';
								|en = 'Упрощенное заявление. Ошибка создание закрытого ключа'") Тогда
		ПричинаОшибки = Параметр;
		ПоказатьОшибкуСозданияКлюча();
		ЗапретитьЗакрытие = Ложь;
	ИначеЕсли ИмяСобытия = НСтр("ru = 'Упрощенное заявление. Ошибка отправки заявления';
								|en = 'Упрощенное заявление. Ошибка отправки заявления'") И НЕ ЗначениеЗаполнено(ПричинаОшибки) Тогда
		// Заходим сюда только если ранее не выпадала ошибка создания контейнера
		ПричинаОшибки = Параметр;
		ПоказатьОшибкуОтправкиЗаявления();
		ЗапретитьЗакрытие = Ложь;
	ИначеЕсли ИмяСобытия = НСтр("ru = 'Упрощенное заявление. Успешная отправки заявления';
								|en = 'Упрощенное заявление. Успешная отправки заявления'")
		ИЛИ ИмяСобытия = НСтр("ru = 'Упрощенное заявление. Отказ от ввода пароля';
								|en = 'Упрощенное заявление. Отказ от ввода пароля'") Тогда
		ЗапретитьЗакрытие = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗапретитьЗакрытие Тогда
		Отказ = Истина;
	Иначе
		Оповестить(НСтр("ru = 'Закрытие Мастер_ОтправкаЗаявления';
						|en = 'Закрытие Мастер_ОтправкаЗаявления'"),,Заявление);	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Оповестить(НСтр("ru = 'Закрытие Мастер_ОтправкаЗаявления';
					|en = 'Закрытие Мастер_ОтправкаЗаявления'"),,Заявление);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РекомендацияКОшибкеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	КонтекстЭДОКлиент.ОбработкаНавигационнойСсылкиИТС(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ИнструкцияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	КонтекстЭДОКлиент.ПоказатьИнструкциюСозданияКонтейнера(ТипКриптопровайдера);
	
КонецПроцедуры

&НаКлиенте
Процедура Шаг1ТекстОбработкаНавигационнойСсылки(Элемент, Ссылка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Ссылка = "сертификат" Тогда
		
		КриптографияЭДКОКлиент.ПоказатьСертификат(Сертификат, ЭтотОбъект);
		
	ИначеЕсли Ссылка = "Заявление на издание нового сертификата" Тогда
		
		Адрес = ОбработкаЗаявленийАбонентаВызовСервера.ДанныеЭлДокументаЗаявления(
			Заявление, "ЗаявлениеНаИзготовлениеСертификата");
			
		ОперацииСФайламиЭДКОКлиент.ОткрытьФайл(Адрес, "ЗаявлениеНаИзготовлениеСертификата.pdf");
		
	ИначеЕсли Ссылка = "Заявление на отзыв текущего сертификата" Тогда
		
		Адрес = ОбработкаЗаявленийАбонентаВызовСервера.ДанныеЭлДокументаЗаявления(
			Заявление, "ЗаявлениеНаОтзывСертификата");
			
		ОперацииСФайламиЭДКОКлиент.ОткрытьФайл(Адрес, "ЗаявлениеНаОтзывСертификата.pdf");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьЗакрытыйКлюч(Команда)
	
	ВладелецФормы.ОтправитьЗаявлениеИзВладельца();
	ПоказатьСтраницуСозданияКлюча();
	
КонецПроцедуры

&НаКлиенте
Процедура ТребуетсяПомощьНажатие(Элемент)
	
	ОбработкаЗаявленийАбонентаКлиент.ОткрытьФормуПомощи(ЭтотОбъект, ФИО, НомерТелефона);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПропуститьСтраницуИнструкцияПоСозданиюКлючаЭЦП()
	
	Возврат ОбработкаЗаявленийАбонента.ПропуститьСтраницуИнструкцияПоСозданиюКлючаЭЦП(Заявление, МестоХраненияКлюча);
		
КонецФункции

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Активизировать();
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	
	Если ПропуститьСтраницуИнструкцияПоСозданиюКлючаЭЦП() Тогда
		ПодключитьОбработчикОжидания("Подключаемый_НачатьОтправкуЗаявленияСразу", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_НачатьОтправкуЗаявленияСразу()
	
	ВладелецФормы.ОтправитьЗаявлениеИзВладельца();
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьСтраницуПодготовкиКСозданиюКлюча()
	
	Если ЭтоУдаленноеПереизданиеСертификата Тогда
		Заголовок = НСтр("ru = 'Перед отправкой:';
						|en = 'Перед отправкой:'");
		Элементы.СоздатьЗакрытыйКлюч.Заголовок = НСтр("ru = 'Создать закрытый ключ и подписать заявления';
														|en = 'Создать закрытый ключ и подписать заявления'");
		ТекущаяСтраница = Элементы.ПолучениеСертификатаВДЛ;
	Иначе
		Заголовок = НСтр("ru = 'Создание ключа и отправка заявления';
						|en = 'Создание ключа и отправка заявления'");
		ТекущаяСтраница = Элементы.ПолучениеСертификатаВКА;
	КонецЕсли;
	
	ДокументооборотСКОКлиентСервер.АктивизироватьСтраницу(
		Элементы.ВариантыНачальнойСтраницы, 
		ТекущаяСтраница);
	
	Элементы.СоздатьЗакрытыйКлюч.КнопкаПоУмолчанию = Истина;
	ЗапретитьЗакрытие = Ложь;
	
	АктивизироватьСтраницу(ЭтотОбъект, Элементы.НачатьСозданиеКлюча);
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьСтраницуОтправкиЗаявления()
	
	Заголовок = НСтр("ru = 'Подождите, пожалуйста...';
					|en = 'Подождите, пожалуйста...'");
	
	Если КриптографияЭДКОКлиентСервер.ЭтоПодписьСервиса(МестоХраненияКлюча) Тогда
		Элементы.ТекстПриОжидании.Заголовок = НСтр("ru = 'Выполняется отправка заявления...
                                                    |Обычно это занимает 1-2 минуты';
                                                    |en = 'Выполняется отправка заявления...
                                                    |Обычно это занимает 1-2 минуты'");
	Иначе
		Элементы.ТекстПриОжидании.Заголовок = НСтр("ru = 'Выполняется отправка заявления...';
													|en = 'Выполняется отправка заявления...'");
	КонецЕсли;
	
	ЗапретитьЗакрытие = Истина;
	АктивизироватьСтраницу(ЭтотОбъект, Элементы.ДлительноеДействие);
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьСтраницуСозданияКлюча()
	
	Заголовок = НСтр("ru = 'Подождите, пожалуйста...';
					|en = 'Подождите, пожалуйста...'");
	
	Элементы.ТекстПриОжидании.Заголовок = НСтр("ru = 'Выполняется создание ключа...';
												|en = 'Выполняется создание ключа...'");
	
	ЗапретитьЗакрытие = Ложь;
	
	АктивизироватьСтраницу(ЭтотОбъект, Элементы.ДлительноеДействие);
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьОшибкуСозданияКлюча()
	
	Заголовок 								 = НСтр("ru = 'Создание ключа';
														|en = 'Создание ключа'");
	Элементы.ЗаголовокКОшибке.Заголовок 	 = НСтр("ru = 'Не удалось создать закрытый ключ по причине:';
													|en = 'Не удалось создать закрытый ключ по причине:'");
	Элементы.ТекстОшибки.Заголовок 			 = ПричинаОшибки;
	Элементы.ФормаЗакрыть.КнопкаПоУмолчанию  = Истина;
	Элементы.БезЭлектроннойПодписи.Видимость = Ложь;
	
	ЗапретитьЗакрытие = Ложь;
	
	АктивизироватьСтраницу(ЭтотОбъект, Элементы.ОписаниеОшибки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОшибкуОтправкиЗаявления()
	
	Заголовок = НСтр("ru = 'Отправка заявления';
					|en = 'Отправка заявления'");
	РеквизитыДокумента       = ОбработкаЗаявленийАбонентаВызовСервера.ПолучитьСтруктуруРеквизитовЗаявления(Заявление);
	ИспользоватьСуществующий = ОбработкаЗаявленийАбонентаКлиентСервер.ИспользоватьСуществующий(РеквизитыДокумента);
	МестоХраненияКлюча 		 = КриптографияЭДКОКлиентСервер.КонтекстМоделиХраненияКлюча(РеквизитыДокумента);
		
	ПричинаОшибки = СтрЗаменить(ПричинаОшибки, Символы.ПС + Символы.ПС, Символы.ПС);
	
	Если СтрНайти(ПричинаОшибки, НСтр("ru = 'Не удалось выполнить подписание сертификатом';
										|en = 'Не удалось выполнить подписание сертификатом'")) <> 0 Тогда
		
		Ошибки = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПричинаОшибки, Символы.Таб);
		
		Элементы.ЗаголовокКОшибке.Заголовок = Ошибки[0];
		Элементы.ТекстОшибки.Заголовок 		= Ошибки[1];
		
		ТолькоПодписание = ПроверитьПодписьОблачногоСервиса(МестоХраненияКлюча, Заявление);
		
		Если ИспользоватьСуществующий ИЛИ ТолькоПодписание Тогда
			Элементы.ФормаЗакрыть.КнопкаПоУмолчанию  = Истина;
			Элементы.БезЭлектроннойПодписи.Видимость = Ложь;
		Иначе
			Элементы.РекомендацияКОшибке.Заголовок 	= НСтр("ru = '
                                                |Попробуйте устранить причину или отправьте заявление без электронной подписи.';
                                                |en = '
                                                |Попробуйте устранить причину или отправьте заявление без электронной подписи.'");
			Элементы.БезЭлектроннойПодписи.КнопкаПоУмолчанию = ТолькоПодписание;
			Элементы.ПустышкаДляВыравнивания.Видимость       = Ложь;
		КонецЕсли;
		
	ИначеЕсли СтрНайти(ПричинаОшибки, НСтр("ru = 'ТикетАутентификацииНаПорталеПоддержки';
											|en = 'ТикетАутентификацииНаПорталеПоддержки'")) <> 0 Тогда
		
		Если ПричинаОшибки = "ТикетАутентификацииНаПорталеПоддержки.КодОшибки:ПревышеноКоличествоПопыток"
			И КриптографияЭДКОКлиентСервер.ЭтоЛокальнаяПодпись(МестоХраненияКлюча) Тогда
			
			Элементы.ТекстОшибки.Заголовок 		   = НСтр("ru = 'Не удалось авторизоваться на Портале 1С:ИТС.
                                                           |Ответ сервера: превышено количество попыток авторизации';
                                                           |en = 'Не удалось авторизоваться на Портале 1С:ИТС.
                                                           |Ответ сервера: превышено количество попыток авторизации'");
			Элементы.РекомендацияКОшибке.Заголовок = КонтекстЭДОКлиент.ТекстДляПревышеноКоличествоПопытокПолученияТикета();

		ИначеЕсли ПричинаОшибки = "ТикетАутентификацииНаПорталеПоддержки.КодОшибки:НеверныйЛогинИлиПароль"
			И КриптографияЭДКОКлиентСервер.ЭтоЛокальнаяПодпись(МестоХраненияКлюча) Тогда
			
			Элементы.ТекстОшибки.Заголовок = НСтр("ru = 'Не удалось авторизоваться на Портале 1С:ИТС';
													|en = 'Не удалось авторизоваться на Портале 1С:ИТС'");
			
			Элементы.РекомендацияКОшибке.Заголовок = Новый ФорматированнаяСтрока(
				Символы.ПС,
				НСтр("ru = 'Для отправки заявления необходимо ';
					|en = 'Для отправки заявления необходимо '"),
				Новый ФорматированнаяСтрока(НСтр("ru = 'задать';
												|en = 'задать'"),,,,"задать логин и пароль от ИТС"),
				НСтр("ru = ' логин и пароль от ';
					|en = ' логин и пароль от '"),
				Новый ФорматированнаяСтрока(НСтр("ru = 'Портала 1С:ИТС';
												|en = 'Портала 1С:ИТС'"),,,,"перейти на Портал ИТС"),
				НСтр("ru = ' и повторить отправку.';
					|en = ' и повторить отправку.'"));

		ИначеЕсли СокрЛП(РеквизитыДокумента.НомерОсновнойПоставки1с) = "" Тогда
			
			Элементы.ТекстОшибки.Заголовок = НСтр("ru = 'Не удалось авторизоваться на Портале 1С:ИТС';
													|en = 'Не удалось авторизоваться на Портале 1С:ИТС'");
			Элементы.РекомендацияКОшибке.Заголовок = НСтр("ru = '
                                                           |Для отправки заявления необходимо заполнить рег. номер программы в заявлении';
                                                           |en = '
                                                           |Для отправки заявления необходимо заполнить рег. номер программы в заявлении'");
			
			Оповестить(НСтр("ru = 'Заполнить рег. номер';
							|en = 'Заполнить рег. номер'"), Истина, Заявление);
			
		Иначе
			
			Элементы.ТекстОшибки.Заголовок = НСтр("ru = 'Не удалось авторизоваться на Портале 1С:ИТС';
													|en = 'Не удалось авторизоваться на Портале 1С:ИТС'");
			Элементы.РекомендацияКОшибке.Заголовок = НСтр("ru = '
                                                           |Обратитесь в службу поддержки или повторите попытку позже.';
                                                           |en = '
                                                           |Обратитесь в службу поддержки или повторите попытку позже.'");
			
			Оповестить(НСтр("ru = 'Заполнить рег. номер';
							|en = 'Заполнить рег. номер'"), Истина, Заявление);
			
		КонецЕсли;
		
		Элементы.ФормаЗакрыть.КнопкаПоУмолчанию    = Истина;
		Элементы.БезЭлектроннойПодписи.Видимость   = Ложь;
		Элементы.ПустышкаДляВыравнивания.Видимость = Истина;		
	Иначе
		Элементы.ЗаголовокКОшибке.Заголовок		   = НСтр("ru = 'Не удалось отправить заявление по причине:';
															|en = 'Не удалось отправить заявление по причине:'");
		Элементы.ТекстОшибки.Заголовок 			   = ПричинаОшибки;
		Элементы.ФормаЗакрыть.КнопкаПоУмолчанию    = Истина;
		Элементы.БезЭлектроннойПодписи.Видимость   = Ложь;
		Элементы.ПустышкаДляВыравнивания.Видимость = Истина;
	КонецЕсли;
	
	ЗапретитьЗакрытие = Ложь;
	
	АктивизироватьСтраницу(ЭтотОбъект, Элементы.ОписаниеОшибки);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура АктивизироватьСтраницу(Форма, ТекущаяСтраница)
	
	ДокументооборотСКОКлиентСервер.АктивизироватьСтраницу(Форма.Элементы.Этапы, ТекущаяСтраница);
	
КонецПроцедуры

&НаКлиенте
Процедура БезЭлектроннойПодписи(Команда)
	
	ВладелецФормы.ОтправитьВБумажномВиде();
	ЗапретитьЗакрытие = Ложь;
	Закрыть();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьПодписьОблачногоСервиса(МестоХраненияКлюча, Заявление)
	
	Результат = Ложь;
	Если КриптографияЭДКОКлиентСервер.ЭтоОблачнаяПодпись(МестоХраненияКлюча)
		И Заявление.ТипЗаявления = Перечисления.ТипыЗаявленияАбонентаСпецоператораСвязи.Изменение Тогда
		СвойствоОблачнойПодписи = ОбработкаЗаявленийАбонентаКлиентСервер.СведенияОблачнойПодписиЗаявления(Заявление);
		Результат = СвойствоОблачнойПодписи.ТребуетИзменения;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ЗапомнитьКлючПоложенияОкна()
	
	Если Заявление.ЭтоУдаленноеПереизданиеСертификата Тогда
		КлючСохраненияПоложенияОкна = "ЭтоУдаленноеПереизданиеСертификата";
	Иначе
		КлючСохраненияПоложенияОкна = "ЭтоНЕУдаленноеПереизданиеСертификата";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УправлениеФормойПриСоздании()
	
	Если ПропуститьСтраницуИнструкцияПоСозданиюКлючаЭЦП() Тогда
		ПоказатьСтраницуОтправкиЗаявления();
	Иначе
		ПоказатьСтраницуПодготовкиКСозданиюКлюча();
	КонецЕсли;
	
	Видимость = 
		Заявление.УдостоверяющийЦентр = Перечисления.УдостоверяющиеЦентрыБРО.УЦФНС
		ИЛИ Заявление.УдостоверяющийЦентр = Перечисления.УдостоверяющиеЦентрыБРО.УЦАналитическийЦентр;
		
	Элементы.ПодсказкаПроТокен.Видимость = Видимость;

КонецПроцедуры

&НаСервере
Процедура ИнициализироватьЗначения()
	
	ТипКриптопровайдера = Заявление.ТипКриптопровайдера;
	ФИО 				= СокрЛП(Заявление.ВладелецЭЦПИмя + " " + Заявление.ВладелецЭЦПОтчество);
	НомерТелефона    	= Заявление.ТелефонМобильныйДляАвторизации;
	
	ОбработкаЗаявленийАбонента.ИнициализироватьСертификат(ЭтотОбъект, Заявление);
	
	ЭтоУдаленноеПереизданиеСертификата = Заявление.ЭтоУдаленноеПереизданиеСертификата;
	
	МестоХраненияКлюча	= КриптографияЭДКОКлиентСервер.ОпределитьМестоХраненияКлюча(
		Заявление.МодельХраненияЗакрытогоКлюча, 
		ОбработкаЗаявленийАбонентаКлиентСервер.ПолучитьПараметрПодключения(Заявление, "УчетнаяЗапись"));
							
КонецПроцедуры

#КонецОбласти