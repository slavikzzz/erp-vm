
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ПараметрКоманды") Тогда
		Если ТипЗнч(Параметры.ПараметрКоманды) = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
			ВходящиеДокументы.Добавить(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.ПараметрКоманды, "ГрафикИсполненияДоговора"));
		Иначе
			ВходящиеДокументы.ЗагрузитьЗначения(Параметры.ПараметрКоманды);
		КонецЕсли;
	ИначеЕсли ЗначениеЗаполнено(Параметры.ВходящиеДокументы) Тогда
		ВходящиеДокументы = Параметры.ВходящиеДокументы;
	Иначе
		Отказ = Истина;
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		СформироватьОтчет();
	Иначе
		ВызватьИсключение НСтр("ru = 'Отчет не предназначен для интерактивного открытия.';
								|en = 'The report is not designed for interactive opening.'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыОтчета

// Параметры:
// 	Элемент - ПолеФормы
// 	Область - ОбластьЯчеекТабличногоДокумента - Содержит:
// 		* Расшифровка - Структура:
// 			** Заказ - ДокументСсылка
// 			** Действие - Строка
// 	СтандартнаяОбработка - Булево
//
&НаКлиенте
Процедура ТаблицаОтчетаВыбор(Элемент, Область, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(Область.Расшифровка) Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	СтруктураПараметров = Область.Расшифровка;
	
	Если СтруктураПараметров.Действие = "ОткрытьСостояниеОбеспечения" Тогда
		
		ПараметрыФормы = ОбеспечениеВДокументахКлиент.ПараметрыФормыСостояниеОбеспеченияЗаказов("ЗАКАЗ");
		ПараметрыФормы.Заказ = СтруктураПараметров.Заказ;
		ПараметрыФормы.ТолькоПросмотр = Истина;
		ОткрытьФорму("Обработка.СостояниеОбеспеченияЗаказов.Форма",
			ПараметрыФормы,
			ЭтаФорма,
			УникальныйИдентификатор);
		
	ИначеЕсли СтруктураПараметров.Действие = "ОткрытьЗначение" Тогда
		ПоказатьЗначение(,СтруктураПараметров.Заказ);
	//++ НЕ УТ
	ИначеЕсли СтруктураПараметров.Действие = "ПоказатьДокументыПередачиСырьяПереработчику" Тогда
		
		НастройкиОтчета = НастройкиОтчетаРасшифровкаСостоянияВыполненияЗаказовПереработчикам(СтруктураПараметров, "ПередачаСырьяПереработчику");
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("РежимРасшифровки", Истина);
		ПараметрыФормы.Вставить("СформироватьПриОткрытии", Истина);
		ПараметрыФормы.Вставить("ПользовательскиеНастройки", НастройкиОтчета);
		ПараметрыФормы.Вставить("КлючВарианта", "ПередачаСырьяПереработчику");
	
		ОткрытьФорму("Отчет.РасшифровкаСостоянияВыполненияЗаказовПереработчикам.ФормаОбъекта", ПараметрыФормы);
		
	ИначеЕсли СтруктураПараметров.Действие = "ПоказатьДокументыПоступленияОтПереработчика" Тогда
		
		НастройкиОтчета = НастройкиОтчетаРасшифровкаСостоянияВыполненияЗаказовПереработчикам(СтруктураПараметров, "ПоступлениеОтПереработчика");
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("РежимРасшифровки", Истина);
		ПараметрыФормы.Вставить("СформироватьПриОткрытии", Истина);
		ПараметрыФормы.Вставить("ПользовательскиеНастройки", НастройкиОтчета);
		ПараметрыФормы.Вставить("КлючВарианта", "ПоступлениеОтПереработчика");
	
		ОткрытьФорму("Отчет.РасшифровкаСостоянияВыполненияЗаказовПереработчикам.ФормаОбъекта", ПараметрыФормы);
	
	ИначеЕсли СтруктураПараметров.Действие = "ПоказатьДокументыПередачиСырьяПереработчику2_5" Тогда
		
		НастройкиОтчета = НастройкиОтчетаРасшифровкаСостоянияВыполненияЗаказовПереработчикам(СтруктураПараметров, "ПередачаТоваровХранителю");
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("РежимРасшифровки", Истина);
		ПараметрыФормы.Вставить("СформироватьПриОткрытии", Истина);
		ПараметрыФормы.Вставить("ПользовательскиеНастройки", НастройкиОтчета);
		ПараметрыФормы.Вставить("КлючВарианта", "ПередачаТоваровХранителю");
	
		ОткрытьФорму("Отчет.РасшифровкаСостоянияВыполненияЗаказовПереработчикам.ФормаОбъекта", ПараметрыФормы);
	
	ИначеЕсли СтруктураПараметров.Действие = "ПоказатьДокументыПоступленияОтПереработчика2_5" Тогда
		
		НастройкиОтчета = НастройкиОтчетаРасшифровкаСостоянияВыполненияЗаказовПереработчикам(СтруктураПараметров, "ПоступлениеТоваровОтХранителя");
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("РежимРасшифровки", Истина);
		ПараметрыФормы.Вставить("СформироватьПриОткрытии", Истина);
		ПараметрыФормы.Вставить("ПользовательскиеНастройки", НастройкиОтчета);
		ПараметрыФормы.Вставить("КлючВарианта", "ПоступлениеТоваровОтХранителя");
	
		ОткрытьФорму("Отчет.РасшифровкаСостоянияВыполненияЗаказовПереработчикам.ФормаОбъекта", ПараметрыФормы);
	//-- НЕ УТ
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сформировать(Команда)
	ОчиститьСообщения();
	СформироватьОтчет();
КонецПроцедуры 

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьОтчет()
	
	ТаблицаОтчета.Очистить();
	Отчеты.СостояниеВыполненияДокументов.СформироватьОтчетСостояниеВыполненияДокументов(ВходящиеДокументы, ТаблицаОтчета);
	
КонецПроцедуры

//++ НЕ УТ

&НаСервереБезКонтекста
Функция НастройкиОтчетаРасшифровкаСостоянияВыполненияЗаказовПереработчикам(Знач СтруктураПараметров, Знач ВариантОтчета)

	ОтчетОбъект = Отчеты.РасшифровкаСостоянияВыполненияЗаказовПереработчикам.Создать();
	
	ПользовательскиеНастройки = ОтчетОбъект.КомпоновщикНастроек.ПользовательскиеНастройки;
	
	ОтчетОбъект.КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ВариантОтчета", ВариантОтчета);
	
	УстанавливаемыеПараметры = Новый Соответствие;
	УстанавливаемыеПараметры.Вставить("Документ", СтруктураПараметров.Документ);
	УстанавливаемыеПараметры.Вставить("Номенклатура", СтруктураПараметров.Номенклатура);
	УстанавливаемыеПараметры.Вставить("Характеристика", СтруктураПараметров.Характеристика);
	
	КомпоновкаДанныхКлиентСервер.УстановитьКоллекциюПараметров(ПользовательскиеНастройки, УстанавливаемыеПараметры);
			
	Возврат ПользовательскиеНастройки;

КонецФункции

//-- НЕ УТ

#КонецОбласти
