
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("СтруктураНастроек") Тогда
		
		Если Параметры.СтруктураНастроек.Свойство("РежимРедактирования") Тогда
			Элементы.ЗаполнитьДокумент.Заголовок = НСтр("ru = 'Сохранить';
														|en = 'Save'");
			РежимРедактирования = Истина;
		Иначе
			РежимРедактирования = Ложь;
		КонецЕсли;
		
		ЭтотОбъект.ФильтроватьНезаполненныеСтроки = Истина;
		ЗаполнятьПоДефициту = Ложь;
		Если Параметры.СтруктураНастроек.Свойство("ЗаполнятьПоДефициту")
			И Параметры.СтруктураНастроек.ЗаполнятьПоДефициту Тогда
			
			ЗаполнятьПоДефициту = Истина;
			
			Элементы.ФильтроватьНезаполненныеСтроки.Видимость = Ложь;
			Элементы.ГруппаФормула.Видимость = Ложь;
			Элементы.ГруппаКомментарийНеИспользоватьСмещение.Видимость = Ложь;
			Элементы.ГруппаСмещение.Видимость = Ложь;
		КонецЕсли;
		
		СтруктураНастроек = Параметры.СтруктураНастроек.СтруктураНастроек;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.СтруктураНастроек,,"ДополнительныеПоля");
		ДополнительныеПоля.Загрузить(Параметры.СтруктураНастроек.ДополнительныеПоля.Выгрузить());
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, СтруктураНастроек);
		
		СхемаКомпоновкиДанных = Обработки.ПодборТоваровПоОтбору.ПолучитьМакет("Макет");
		АдресСхемыКомпоновкиДанных = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, УникальныйИдентификатор);
		ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновкиДанных); 
		ОтборНоменклатуры.Инициализировать(ИсточникНастроек);
		ОтборНоменклатуры.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
		Если СтруктураНастроек.Свойство("ОтборНоменклатурыНастройки")
			И ЗначениеЗаполнено(Строка(СтруктураНастроек.ОтборНоменклатурыНастройки.Отбор))Тогда
			ОтборНоменклатуры.ЗагрузитьНастройки(СтруктураНастроек.ОтборНоменклатурыНастройки);
			СформироватьПредставлениеОтбораНоменклатуры();
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ФормулаПредставление) Тогда
			ФормулаПредставление = ПланированиеКлиентСервер.ТекстУстановкиНовойФормулы()
		КонецЕсли;
		
		Если СмещениеПериода >= 0 Тогда
		
			НаправлениеСмещения = 1;
			СмещениеРедактируемое = СмещениеПериода;
		
		Иначе
		
			НаправлениеСмещения = -1;
			СмещениеРедактируемое = НаправлениеСмещения * СмещениеПериода;
		
		КонецЕсли; 
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВидЦены) Тогда
		ВидЦены = ЦенообразованиеВызовСервера.ВидЦеныПрайсЛист();
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(НачалоПериодаПлан) ИЛИ Не ЗначениеЗаполнено(ОкончаниеПериодаПлан) Тогда
		ПланированиеКлиентСервер.УстановитьНачалоОкончаниеПериодаПлана(
			Периодичность,
			НачалоПериодаПлан,
			ОкончаниеПериодаПлан,
			ТекущаяДатаСеанса(),
			Параметры.СтруктураНастроек.КоличествоПериодов);
	КонецЕсли;
	
	ОбновитьПериодПриИзмененииСмещения(ЭтотОбъект);
	
	УстановитьВидимостьСтраницФормыИДоступностьЭлементов(РежимРедактирования, ЗаполнятьПоДефициту);

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив();
	
	Если Не (ПланироватьПоСумме И ВариантЗаполненияЦен = "ЦеныНоменклатуры" И ИспользоватьВидЦены) Тогда
		НепроверяемыеРеквизиты.Добавить("ВидЦены");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ВариантСмещенияПриИзменении(Элемент)
	
	ПриИзмененииСмещения(ЭтаФорма);
	
	ОбновитьПериодПриИзмененииСмещения(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СмещениеПриИзменении(Элемент)
	
	ОбновитьПериодПриИзмененииСмещения(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НаправлениеСмещенияПриИзменении(Элемент)
	
	ОбновитьПериодПриИзмененииСмещения(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантЗаполненияЦенСоглашениеПриИзменении(Элемент)
	
	ПриИзмененииВариантаЦен(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантЗаполненияЦенПартнерПриИзменении(Элемент)
	
	ПриИзмененииВариантаЦен(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьВидЦеныПриИзменении(Элемент)
	
	ВариантЗаполненияЦен = "ЦеныНоменклатуры";
	ПриИзмененииИспользоватьВидЦены(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ФормулаПредставлениеНажатие(Элемент, СтандартнаяОбработка)
	
	ОткрытьДиалогРедактированияФормулы();
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияОтборНоменклатурыОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Оповещение = Новый ОписаниеОповещения("ДекорацияОтборНоменклатурыОбработкаНавигационнойСсылкиЗавершение", ЭтаФорма);
		
	ПараметрыФормыРедактирования = Новый Структура("АдресНастроек,ИмяАдресМакета",
			 ОтборНоменклатурыНастройки(),
			"Обработка.ПодборТоваровПоОтбору.Макет");
	
	ОткрытьФорму("ОбщаяФорма.РедактированиеНастроекКомпоновкиДанных",
		ПараметрыФормыРедактирования,
		ЭтаФорма,
		,
		,
		,
		Оповещение,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
КонецПроцедуры

&НаКлиенте
Процедура ВариантЗаполненияСоставаПриИзменении(Элемент)
	
	ПриИзмененииВариантЗаполнения(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьДокумент(Команда)
	
	СмещениеПериода = НаправлениеСмещения * СмещениеРедактируемое;
	
	ЗаполнитьЗначенияСвойств(СтруктураНастроек, ЭтотОбъект);
	СтруктураНастроек.Вставить("ОтборНоменклатурыНастройки", ОтборНоменклатурыНастройки());
	
	ВсеЗаполнено = ПроверитьЗаполнение();
	
	Если ВсеЗаполнено Тогда
		
		СохранитьНастройки();
		Закрыть(СтруктураНастроек);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ПриИзмененииСмещения(Форма)
	
	Если Форма.ВариантСмещения = "Произвольное" Тогда
		Форма.Элементы.СмещениеРедактируемое.Доступность = Истина;
		Форма.Элементы.НаправлениеСмещения.Доступность = Истина;
	Иначе
		Форма.Элементы.СмещениеРедактируемое.Доступность = Ложь;
		Форма.Элементы.НаправлениеСмещения.Доступность = Ложь;
	КонецЕсли;
	
	Если Форма.ВариантСмещения = "ПредыдущийПериод" Тогда
		Форма.СмещениеРедактируемое = 1;
		Форма.НаправлениеСмещения = -1;
	ИначеЕсли Форма.ВариантСмещения = "ТекущийПериод" Тогда
		Форма.СмещениеРедактируемое = 0;
		Форма.НаправлениеСмещения = -1;
	ИначеЕсли Форма.ВариантСмещения = "ПредыдущийГод" Тогда
		
		Форма.НаправлениеСмещения = -1;
		
		Если Форма.Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда
			Форма.СмещениеРедактируемое = 12;
		ИначеЕсли Форма.Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.День") Тогда
			Форма.СмещениеРедактируемое = ДеньГода(КонецГода(Форма.НачалоПериодаПлан));
		ИначеЕсли Форма.Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Неделя") Тогда
			Форма.СмещениеРедактируемое = НеделяГода(КонецГода(Форма.НачалоПериодаПлан)) - 1;
		ИначеЕсли Форма.Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Декада") Тогда
			Форма.СмещениеРедактируемое = 36;
		ИначеЕсли Форма.Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Квартал") Тогда
			Форма.СмещениеРедактируемое = 4;
		ИначеЕсли Форма.Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Полугодие") Тогда
			Форма.СмещениеРедактируемое = 2;
		ИначеЕсли Форма.Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Год") Тогда
			Форма.СмещениеРедактируемое = 1;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьПериодПриИзмененииСмещения(Форма) 

	Форма.НачалоПериодаСмещенный = ПересчитатьНачалоПериода(Форма.НачалоПериодаПлан, Форма.Периодичность, Форма.СмещениеРедактируемое, Форма.НаправлениеСмещения);
	Форма.ОкончаниеПериодаСмещенный = ПересчитатьОкончаниеПериода(Форма.ОкончаниеПериодаПлан, Форма.Периодичность, Форма.СмещениеРедактируемое, Форма.НаправлениеСмещения);
	
	УстановитьПериодПрописью(Форма.СмещениеПериода, Форма.Периодичность, Форма.ПериодичностьПредставление);
	
	Форма.ПериодСмещенныйПредставление = СформироватьПредставлениеПериода(Новый Структура("Периодичность, НачалоПериода, ОкончаниеПериода", Форма.Периодичность, Форма.НачалоПериодаСмещенный, Форма.ОкончаниеПериодаСмещенный));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СформироватьПредставлениеПериода(Параметры) 

	Представление = "";
	
	НачалоПериода 		= Параметры.НачалоПериода;
	ОкончаниеПериода	= Параметры.ОкончаниеПериода;
	Периодичность 		= Параметры.Периодичность;
	
	#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
		ТекущаяДатаСеанса = ТекущаяДатаСеанса();
	#Иначе 
		ТекущаяДатаСеанса = ОбщегоНазначенияКлиент.ДатаСеанса();
	#КонецЕсли
	
	ПланированиеКлиентСервер.УстановитьНачалоОкончаниеПериодаПлана(Периодичность, НачалоПериода, ОкончаниеПериода, ТекущаяДатаСеанса);
	
	Если Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда
		
		ФорматПериодичностьМесяц = НСтр("ru = 'ДФ=''ММММ гггг''';
										|en = 'DF=''MMMM yyyy'''");
		Если НачалоМесяца(НачалоПериода) = НачалоМесяца(ОкончаниеПериода) Тогда
			Представление = Формат(НачалоПериода, ФорматПериодичностьМесяц);
		Иначе
			Представление = Формат(НачалоПериода, ФорматПериодичностьМесяц) + " - " + Формат(ОкончаниеПериода, ФорматПериодичностьМесяц);
		КонецЕсли;
		
	ИначеЕсли Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.День") Тогда
		
		ФорматПериодичностьДень = "ДЛФ=DD";
		Если НачалоДня(НачалоПериода) = НачалоДня(ОкончаниеПериода) Тогда
			Представление = Формат(НачалоПериода, ФорматПериодичностьДень);
		Иначе
			Представление = Формат(НачалоПериода, ФорматПериодичностьДень) + " - " + Формат(ОкончаниеПериода, ФорматПериодичностьДень);
		КонецЕсли;
		
	Иначе
		
		Представление = Формат(НачалоПериода, "ДЛФ=DD") + " - " + Формат(ОкончаниеПериода, "ДЛФ=DD");
		
	КонецЕсли;
	
	Возврат Представление;

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПересчитатьОкончаниеПериода(Знач НачалоПериода, Знач Периодичность, Знач Смещение, Знач НаправлениеСмещения)
	
	Смещение = НаправлениеСмещения * Смещение;
	
	Результат = ОбщегоНазначенияУТКлиентСервер.РассчитатьДатуОкончанияПериода(НачалоПериода, Периодичность, Смещение);
	
	Результат = ПланированиеКлиентСерверПовтИсп.РассчитатьДатуОкончанияПериода(Результат + 1, Периодичность);
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПересчитатьНачалоПериода(Знач НачалоПериода, Знач Периодичность, Знач Смещение, Знач НаправлениеСмещения)
	
	Смещение = НаправлениеСмещения * Смещение;
	
	Результат = ОбщегоНазначенияУТКлиентСервер.РассчитатьДатуОкончанияПериода(НачалоПериода, Периодичность, Смещение);
	
	Результат = ПланированиеКлиентСерверПовтИсп.РассчитатьДатуНачалаПериода(Результат + 1, Периодичность);
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПериодПрописью(Знач Смещение, Знач Периодичность, ПериодичностьПредставление)

	ПериодичностьПредставление = МониторингЦелевыхПоказателейКлиентСервер.ПериодПрописью(Смещение, Периодичность);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПриИзмененииВариантаЦен(Форма)
	
	Если Форма.ВариантЗаполненияЦен = "ЦеныНоменклатуры" Тогда
		Форма.Элементы.ВидЦеныПартнер.Доступность 	= Истина;
		Форма.Элементы.ВидЦеныСоглашение.Доступность= Истина;
		Если Форма.ЗаполнятьПартнера ИЛИ Форма.ЗаполнятьСоглашение Тогда
			Форма.ИспользоватьВидЦены = Истина;
		КонецЕсли;
	Иначе
		Форма.Элементы.ВидЦеныПартнер.Доступность 	= Ложь;
		Форма.Элементы.ВидЦеныСоглашение.Доступность= Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПриИзмененииИспользоватьВидЦены(Форма)
	
	Если Форма.ИспользоватьВидЦены Тогда
		Форма.Элементы.ВидЦены.Доступность = Истина;
	Иначе
		Форма.Элементы.ВидЦены.Доступность = Ложь;
	КонецЕсли;
	
	СкорректироватьВариантЗаполненияЦен(Форма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПриИзмененииВариантЗаполнения(Форма)
	
	Форма.Элементы.ДекорацияОтборНоменклатуры.Доступность = Форма.ВариантЗаполненияСостава = "Отбор";
	Форма.Элементы.ФильтроватьНезаполненныеСтроки.Доступность = Форма.ВариантЗаполненияСостава <> "Дефицит";
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура СкорректироватьВариантЗаполненияЦен(Форма)

	Если Форма.ЗаполнятьПартнера И Форма.ВариантЗаполненияЦен = "ЦеныНоменклатурыПоставщиков" И НЕ Форма.ЗаполнятьСоглашение Тогда
		Форма.ВариантЗаполненияЦен = "МинимальнаяЦенаПоставщика";
	ИначеЕсли Форма.ЗаполнятьСоглашение И Форма.ВариантЗаполненияЦен = "МинимальнаяЦенаПоставщика" Тогда
		Форма.ВариантЗаполненияЦен = "ЦеныНоменклатурыПоставщиков";
	ИначеЕсли Не Форма.ВариантЗаполненияЦен = "ЦеныНоменклатуры" И НЕ Форма.ЗаполнятьПартнера И НЕ Форма.ЗаполнятьСоглашение Тогда
		Форма.ВариантЗаполненияЦен = "ЦеныНоменклатуры";
	КонецЕсли;
	
	Если Форма.ВариантЗаполненияЦен = "ЦеныНоменклатуры"
		И (Форма.ЗаполнятьПартнера ИЛИ Форма.ЗаполнятьСоглашение)
		И Форма.ТипПлана = ПредопределенноеЗначение("Перечисление.ТипыПланов.ПланЗакупок") Тогда
		Форма.ИспользоватьВидЦены = Истина;
	КонецЕсли; 

КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьСтраницФормыИДоступностьЭлементов(РежимРедактирования, ЗаполнятьПоДефициту)
	
	ВариантыЗаполненияСостава = Новый Массив;
	
	Если ТипПлана = Перечисления.ТипыПланов.ПланПродаж Тогда
		
		Вариант = Новый Структура("Источник, Представление, Описание");
		Вариант.Источник = "ТоварыПриобретенныеКлиентом";
		Если ЗаполнятьПартнера Тогда
		
			Вариант.Представление = НСтр("ru = 'по товарам, приобретенным клиентом';
										|en = 'by goods purchased by customer'");
			Вариант.Описание = НСтр("ru = 'Вся номенклатура, приобретенная выбранным в документе клиентом.';
									|en = 'All products purchased by the customer specified in the document.'");
		
		Иначе
		
			Вариант.Представление = НСтр("ru = 'по товарам, приобретенным всеми клиентами';
										|en = 'by goods purchased by all customers'");
			Вариант.Описание = НСтр("ru = 'Вся номенклатура, приобретенная всеми клиентами.';
									|en = 'All products purchased by all customers.'");
		
		КонецЕсли; 
		ВариантыЗаполненияСостава.Добавить(Вариант);
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьАссортимент") Тогда
			
			Вариант = Новый Структура("Источник, Представление, Описание");
			Вариант.Источник = "АссортиментПродаж";
			Вариант.Представление = НСтр("ru = 'по ассортименту';
										|en = 'by product range'");
			Вариант.Описание = НСтр("ru = 'Позволяет заполнить номенклатуру по ассортименту, разрешенному к продаже.';
									|en = 'Allows you to fill in items by the product range allowed for sales.'");
			ВариантыЗаполненияСостава.Добавить(Вариант);
		
		КонецЕсли; 
		
	ИначеЕсли ТипПлана = Перечисления.ТипыПланов.ПланПродажПоКатегориям Тогда
		Элементы.ГруппаВариантЗаполненияСостава.Заголовок = НСтр("ru = 'Заполнять состав товарных категорий по:';
																|en = 'Fill in product categories by:'");
		
		Если ЗаполнятьСклад Тогда
			
			Вариант = Новый Структура("Источник, Представление, Описание");
			Вариант.Источник = "ТоварныеКатегорииСкладаФормат";
			Вариант.Представление = НСтр("ru = 'по всем товарным категориям';
										|en = 'by all product categories'");
			Вариант.Описание = НСтр("ru = 'Все товарные категории, которые участвовали в продажах на складе (в формате магазина).';
									|en = 'All product categories which participated in sales at warehouse (in the store format).'");
			ВариантыЗаполненияСостава.Добавить(Вариант);
			
		
		Иначе
			
			Вариант = Новый Структура("Источник, Представление, Описание");
			Вариант.Источник = "ТоварныеКатегории";
			Вариант.Представление = НСтр("ru = 'по всем товарным категориям';
										|en = 'by all product categories'");
			Вариант.Описание = НСтр("ru = 'Вся товарные категории, которые участвовали в продажах.';
									|en = 'All product categories which participated in sales.'");
			ВариантыЗаполненияСостава.Добавить(Вариант);
		
		КонецЕсли; 
		
		Вариант = Новый Структура("Источник, Представление, Описание");
		Вариант.Источник = "Формула";
		Вариант.Представление = НСтр("ru = 'по формуле';
									|en = 'by formula'");
		Вариант.Описание = НСтр("ru = 'Товарные категории будут получены из операндов (источников), указанных в формуле ниже.';
								|en = 'Product categories will be received from operands (sources) specified in the formula below.'");
		ВариантыЗаполненияСостава.Добавить(Вариант);
		
		Вариант = Новый Структура("Источник, Представление, Описание");
		Вариант.Источник = "Отбор";
		Вариант.Представление = НСтр("ru = 'по отбору';
									|en = 'by filter'");
		Вариант.Описание = НСтр("ru = 'Позволяет заполнить товарные категории по произвольным отборам, установленным в документе.';
								|en = 'Allows you to fill in the product categories by arbitrary filters set in the document.'");
		ВариантыЗаполненияСостава.Добавить(Вариант);
		
	ИначеЕсли ТипПлана = Перечисления.ТипыПланов.ПланСборкиРазборки Тогда
		
		Вариант = Новый Структура("Источник, Представление, Описание");
		Вариант.Источник = "СборкаКомплектыВарианты";
		Вариант.Представление = НСтр("ru = 'по собираемым комплектам';
									|en = 'by assembled kits'");
		Вариант.Описание = НСтр("ru = 'Номенклатура, для которой создан хотя бы один вариант комплектации.';
								|en = 'Items that have one or more product kit configurations created.'");
		ВариантыЗаполненияСостава.Добавить(Вариант);
		
		Вариант = Новый Структура("Источник, Представление, Описание");
		Вариант.Источник = "СборкаКомплекты";
		Вариант.Представление = НСтр("ru = 'по признаку использования в сборке';
									|en = 'by attribute indicating that it is included in kitting'");
		Вариант.Описание = НСтр("ru = 'Позволяет заполнить номенклатуру, которая когда-либо собиралась.';
								|en = 'Allows you to fill in items which were assembled at any time.'");
		ВариантыЗаполненияСостава.Добавить(Вариант);
		
	ИначеЕсли ТипПлана = Перечисления.ТипыПланов.ПланВнутреннихПотреблений Тогда
		
		Вариант = Новый Структура("Источник, Представление, Описание");
		Вариант.Источник = "ТоварыСписанныеНаВнутренниеПотребности";
		Вариант.Представление = НСтр("ru = 'по признаку списания на расходы';
									|en = 'by the flag of write-off as expenses'");
		Вариант.Описание = НСтр("ru = 'Позволяет заполнить товары, которые когда-либо списывались на обеспечение внутренних потребностей.';
								|en = 'Fill in the goods that have ever been written off for internal needs.'");
		ВариантыЗаполненияСостава.Добавить(Вариант);
		
	//++ НЕ УТ
	ИначеЕсли ТипПлана = Перечисления.ТипыПланов.ПланПроизводства Тогда
		
		Вариант = Новый Структура("Источник, Представление, Описание");
		Вариант.Источник = "ПроизводимаяПродукция";
		Вариант.Представление = НСтр("ru = 'по производимой продукции';
									|en = 'by manufactured products'");
		Вариант.Описание = НСтр("ru = 'Позволяет заполнить номенклатуру, которая когда-либо производилась.';
								|en = 'Allows you to fill in items which were manufactured at any time.'");
		ВариантыЗаполненияСостава.Добавить(Вариант);
		
	//-- НЕ УТ
	ИначеЕсли ТипПлана = Перечисления.ТипыПланов.ПланЗакупок Тогда
		
		Вариант = Новый Структура("Источник, Представление, Описание");
		Вариант.Источник = "НоменклатураКонтрагентов";
		Если ЗаполнятьПартнера Тогда
			Вариант.Представление = НСтр("ru = 'по номенклатуре поставщика';
										|en = 'by vendor part numbers'");
			Вариант.Описание = НСтр("ru = 'Позволяет заполнить по зарегистрированной номенклатуре поставщика.';
									|en = 'Allows you to fill in items by the vendor''s part numbers'");
		Иначе
			Вариант.Представление = НСтр("ru = 'по всей номенклатуре поставщиков';
										|en = 'by all vendors'' part numbers'");
			Вариант.Описание = НСтр("ru = 'Позволяет заполнить по зарегистрированной номенклатуре всех поставщиков.';
									|en = 'Allows you to fill in items by part numbers of all vendors.'");
		КонецЕсли;
		ВариантыЗаполненияСостава.Добавить(Вариант);
		
		Вариант = Новый Структура("Источник, Представление, Описание");
		Вариант.Источник = "ТоварыПриобретенныеУПоставщика";
		Если ЗаполнятьПартнера Тогда
			Вариант.Представление = НСтр("ru = 'по товарам, приобретенным у поставщика';
										|en = 'by goods purchased from the vendor'");
			Вариант.Описание = НСтр("ru = 'Вся номенклатура, приобретенная у выбранного поставщика.';
									|en = 'All products purchased from the selected vendor.'");
		Иначе
			Вариант.Представление = НСтр("ru = 'по товарам, приобретенным у всех поставщиков';
										|en = 'by goods purchased from all vendors'");
			Вариант.Описание = НСтр("ru = 'Вся номенклатура, приобретенная у всех поставщиков.';
									|en = 'All products purchased from all vendors.'");
		КонецЕсли;
		ВариантыЗаполненияСостава.Добавить(Вариант);
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьАссортимент") Тогда
			
			Вариант = Новый Структура("Источник, Представление, Описание");
			Вариант.Источник = "АссортиментЗакупок";
			Вариант.Представление = НСтр("ru = 'по ассортименту';
										|en = 'by product range'");
			Вариант.Описание = НСтр("ru = 'Позволяет заполнить номенклатуру по ассортименту, разрешенному к закупкам.';
									|en = 'Allows you to fill in items by the product range allowed for purchase.'");
			ВариантыЗаполненияСостава.Добавить(Вариант);
		
		КонецЕсли;
		
	КонецЕсли;
	
	Если (ТипПлана = Перечисления.ТипыПланов.ПланПродаж
		//++ НЕ УТ
		ИЛИ ТипПлана = Перечисления.ТипыПланов.ПланПроизводства
		//-- НЕ УТ
		ИЛИ ТипПлана = Перечисления.ТипыПланов.ПланСборкиРазборки
		ИЛИ ТипПлана = Перечисления.ТипыПланов.ПланВнутреннихПотреблений
		ИЛИ ТипПлана = Перечисления.ТипыПланов.ПланЗакупок
		ИЛИ ТипПлана = Перечисления.ТипыПланов.ПланОстатков) Тогда
		
		Если Не ЗаполнятьПоДефициту Тогда
			Вариант = Новый Структура("Источник, Представление, Описание");
			Вариант.Источник = "Формула";
			Вариант.Представление = НСтр("ru = 'из формулы';
										|en = 'from formula'");
			Вариант.Описание = НСтр("ru = 'Номенклатура будет получена из операндов, указанных в формуле ниже.';
									|en = 'Item will be received from the operands specified in the formula below.'");
			ВариантыЗаполненияСостава.Добавить(Вариант);
		КонецЕсли;
		
		Если Не РежимРедактирования Тогда
			Вариант = Новый Структура("Источник, Представление, Описание");
			Вариант.Источник = "НеМенять";
			Вариант.Представление = НСтр("ru = 'не менять';
										|en = 'do not change'");
			Вариант.Описание = НСтр("ru = 'Состав номенклатуры из плана не меняется.';
									|en = 'Product content from plan is not changed.'");
			ВариантыЗаполненияСостава.Добавить(Вариант);
			
			Вариант = Новый Структура("Источник, Представление, Описание");
			Вариант.Источник = "Отбор";
			Вариант.Представление = НСтр("ru = 'по отбору';
										|en = 'by filter'");
			Вариант.Описание = НСтр("ru = 'Позволяет заполнить номенклатуру по произвольным отборам, установленным в документе.';
									|en = 'Allows you to fill in the products by the arbitrary filters set in the document.'");
			ВариантыЗаполненияСостава.Добавить(Вариант);
		КонецЕсли;
	
	КонецЕсли;
	
	Если ЗаполнятьПоДефициту Тогда
		
		Вариант = Новый Структура("Источник, Представление, Описание");
		Вариант.Источник = "Дефицит";
		Вариант.Представление = НСтр("ru = 'по дефициту';
									|en = 'by shortage'");
		Вариант.Описание = НСтр("ru = 'Заполняет номенклатуру по которой имеется дефицит, сформированный другими планам.';
								|en = 'Fills in the products with a shortage caused by other plans.'");
		ВариантыЗаполненияСостава.Добавить(Вариант);
		
	КонецЕсли;
	
	Элементы.ВариантЗаполненияСостава.СписокВыбора.Очистить();
	
	Индекс = 1;
	Для каждого Вариант Из ВариантыЗаполненияСостава Цикл
		
		Если Вариант.Источник =  "Отбор" Тогда
			Продолжить;
		КонецЕсли;
		
		Элементы.ВариантЗаполненияСостава.СписокВыбора.Добавить(Вариант.Источник, Вариант.Представление);
		ЭлементВариантЗаполненияСоставаПояснение = Элементы["ВариантЗаполненияСоставаПояснение"+Индекс]; // ДекорацияФормы - 
		Вариант.Свойство("Описание", ЭлементВариантЗаполненияСоставаПояснение.Заголовок);
		Индекс = Индекс + 1;
	КонецЦикла;
	
	Пока Индекс <= 5 Цикл
	
		Элементы["ВариантЗаполненияСоставаПояснение"+Индекс].Видимость = Ложь;
		Индекс = Индекс + 1;
	
	КонецЦикла; 
	
	Элементы.ГруппаВидЦеныЗакупки.Видимость = Ложь;
	Элементы.ГруппаЦеныПартнер.Видимость = Ложь;
	Элементы.ГруппаЦеныСоглашение.Видимость = Ложь;
	
	Элементы.ФильтроватьПоНаличиюСпецификации.Видимость = Ложь;
	//++ НЕ УТКА
	Элементы.ФильтроватьПоНаличиюСпецификации.Видимость = (ТипПлана = Перечисления.ТипыПланов.ПланПроизводства);
	//-- НЕ УТКА
	
	Если ТипПлана = Перечисления.ТипыПланов.ПланПродаж И ПланироватьПоСумме Тогда
		Элементы.ГруппаВидЦеныЗакупки.Видимость = Истина;
	ИначеЕсли ТипПлана = Перечисления.ТипыПланов.ПланЗакупок И ПланироватьПоСумме Тогда
	
		Если ЗаполнятьПартнера Тогда
		
			Если ЗаполнятьСоглашение Тогда
				Элементы.ГруппаЦеныСоглашение.Видимость = Истина;
			Иначе
				Элементы.ГруппаЦеныПартнер.Видимость = Истина;
			КонецЕсли;
		
		Иначе
		
			Элементы.ГруппаВидЦеныЗакупки.Видимость = Истина;
		
		КонецЕсли; 
	
	КонецЕсли;
	
	УстановитьДоступностьНастройкиСмещения(ЭтаФорма);
	
	ПриИзмененииСмещения(ЭтаФорма);
	ОбновитьПериодПриИзмененииСмещения(ЭтотОбъект);
	ПриИзмененииВариантаЦен(ЭтаФорма);
	ПриИзмененииИспользоватьВидЦены(ЭтаФорма);
	ПриИзмененииВариантЗаполнения(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьНастройкиСмещения(Форма)
	
	Если СтрНайти(Форма.Формула , "ПланируемыеНачальныеОстатки") <> 0
		Или СтрНайти(Форма.Формула , "ПланируемыеКонечныеОстатки") <> 0
		Или СтрНайти(Форма.Формула , "ПланируемыйКонечныйДефицит") <> 0 Тогда
		
		Форма.ВариантСмещения = "ТекущийПериод";
		Форма.СмещениеРедактируемое = 0;
		Форма.Элементы.ГруппаКомментарийНеИспользоватьСмещение.Видимость = Форма.Элементы.ГруппаСмещение.Видимость;
		
		Форма.Элементы.ВариантСмещенияПредыдущийПериод.Доступность = Ложь;
		Форма.Элементы.ВариантСмещенияПредыдущийГод.Доступность = Ложь;
		Форма.Элементы.ГруппаВариантСмещенияПроизвольное.Доступность = Ложь;
		
	Иначе
		Форма.Элементы.ГруппаКомментарийНеИспользоватьСмещение.Видимость = Ложь;
		
		Форма.Элементы.ВариантСмещенияПредыдущийПериод.Доступность = Истина;
		Форма.Элементы.ВариантСмещенияПредыдущийГод.Доступность = Истина;
		Форма.Элементы.ГруппаВариантСмещенияПроизвольное.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДиалогРедактированияФормулы()
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Расширенный",Истина);
	ПараметрыФормы.Вставить("ВключитьЗначение",Ложь);
	ПараметрыФормы.Вставить("Формула",?(Формула = НСтр("ru = 'Задать формулу';
														|en = 'Set formula'"),"", Формула));
	ПараметрыФормы.Вставить("Представление",?(ФормулаПредставление = ПланированиеКлиентСервер.ТекстУстановкиНовойФормулы(),
		"", ФормулаПредставление));
	ПараметрыФормы.Вставить("ДеревоОперандов",ПоместитьДополнительныеПоляВХранилище());
	ПараметрыФормы.Вставить("Операторы",АдресХранилищаДереваОператоров);
	ПараметрыФормы.Вставить("ТипРезультата", Новый ОписаниеТипов("Число"));
	ПараметрыФормы.Вставить("ФункцииИзОбщегоМодуля", ПланированиеКлиент.ФункцииИзОбщегоМодуля());
	ПараметрыФормы.Вставить("КлючОбъектаСохраняемыхНастроек", "НастройкиРаботыПользователя" + ТипПлана);
	ПараметрыФормы.Вставить("Отбор", Отбор);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗадатьПроизвольнуюФормулу",ЭтотОбъект);
	Режим = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	
	ОткрытьФорму("ОбщаяФорма.КонструкторФормул", ПараметрыФормы, ЭтаФорма,,,,ОписаниеОповещения,Режим);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадатьПроизвольнуюФормулу(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если СмещениеРедактируемое <> 0 
		И (СтрНайти(Результат.Формула , "ПланируемыеНачальныеОстатки")<>0
		Или СтрНайти(Результат.Формула , "ПланируемыеКонечныеОстатки")<>0
		Или СтрНайти(Результат.Формула , "ПланируемыйКонечныйДефицит")<>0) Тогда
		
		ТекстВопроса = НСтр("ru = 'В формуле присутствует операнд по вычислению планируемого остатка, данные могут быть получены только из текущего периода. Изменить текущие настройки смещения и продолжить?';
							|en = 'There is an operand for planned balance calculation in the formula, the data can be received only from the current period. Change the current offset settings and continue?'");
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ЗадатьПроизвольнуюФормулуЗавершение", ЭтотОбъект, Результат), 
				ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе
		Формула = ?(ЗначениеЗаполнено(Результат.Формула), Результат.Формула, ПланированиеКлиентСервер.ТекстУстановкиНовойФормулы());
		ФормулаПредставление = ?(ЗначениеЗаполнено(Результат.Представление) 
		И Формула <> ПланированиеКлиентСервер.ТекстУстановкиНовойФормулы(), Результат.Представление, Формула);
		
		УстановитьДоступностьНастройкиСмещения(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадатьПроизвольнуюФормулуЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Результат = ДополнительныеПараметры;
	Ответ = РезультатВопроса;
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	Иначе
		Формула = ?(ЗначениеЗаполнено(Результат.Формула), Результат.Формула, ПланированиеКлиентСервер.ТекстУстановкиНовойФормулы());
		ФормулаПредставление = ?(ЗначениеЗаполнено(Результат.Представление) 
		И Формула <> ПланированиеКлиентСервер.ТекстУстановкиНовойФормулы(), Результат.Представление, Формула);
		
		УстановитьДоступностьНастройкиСмещения(ЭтаФорма);
		ОбновитьПериодПриИзмененииСмещения(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПоместитьДополнительныеПоляВХранилище()
	
	Возврат Планирование.ПоместитьДополнительныеПоляВХранилище(ЭтаФорма, 0);
	
КонецФункции

&НаКлиенте
Процедура СохранитьНастройки()
	
	ЗаполнитьЗначенияСвойств(СтруктураНастроек, ЭтотОбъект);
	СтруктураНастроек.Вставить("ОтборНоменклатурыНастройки", ОтборНоменклатурыНастройки());
	СтруктураНастроек.Вставить("ФильтроватьНезаполненныеСтроки", ЭтотОбъект.ФильтроватьНезаполненныеСтроки);
	СтруктураНастроек.Вставить("ФильтроватьПоНаличиюСпецификации", ЭтотОбъект.ФильтроватьПоНаличиюСпецификации);
	
	СохранитьНастройкиНаСервере(СтруктураНастроек, ТипПлана);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьНастройкиНаСервере(СтруктураНастроек, ТипПлана)
	
	КлючОбъекта = "НастройкиРаботыПользователя" + ТипПлана;
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(КлючОбъекта, "СтруктураНастроек", СтруктураНастроек);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияОтборНоменклатурыОбработкаНавигационнойСсылкиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено 
		Или Не ЭтоАдресВременногоХранилища(Результат) Тогда
		Возврат;
	КонецЕсли;
	ОбработатьИзменениеОтбораНоменклатуры(Результат);
	
КонецПроцедуры

&НаСервере
Функция ОтборНоменклатурыНастройки()
	Возврат ОтборНоменклатуры.ПолучитьНастройки();	
КонецФункции

&НаСервере
Процедура ОбработатьИзменениеОтбораНоменклатуры(АдресОтбора)
	
	ОтборНоменклатурыНастройка = ПолучитьИзВременногоХранилища(АдресОтбора);
	УдалитьИзВременногоХранилища(АдресОтбора);
	
	ОтборНоменклатуры.ЗагрузитьНастройки(ОтборНоменклатурыНастройка);
	СформироватьПредставлениеОтбораНоменклатуры();
	
КонецПроцедуры

&НаСервере
Процедура СформироватьПредставлениеОтбораНоменклатуры()
	
	МассивСтрок = Новый Массив;
	//МассивСтрок.Добавить("Отбор номенклатуры: ");
	ПредставлениеОтбора = Строка(ОтборНоменклатуры.Настройки.Отбор);
	Если ЗначениеЗаполнено(ПредставлениеОтбора) Тогда
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'изменить';
																|en = 'change'"),,,,"Фильтр"));
	Иначе
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'не установлен';
																|en = 'not set'"),,,,"Фильтр"));
	КонецЕсли;
	Элементы.ДекорацияОтборНоменклатуры.Заголовок = Новый ФорматированнаяСтрока(МассивСтрок);
	
КонецПроцедуры

#КонецОбласти
