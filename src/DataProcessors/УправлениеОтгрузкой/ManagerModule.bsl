#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	Если ПравоДоступа("Изменение", Метаданные.Документы.РасходныйОрдерНаТовары) Тогда
		// Расходный ордер на товары
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.МенеджерПечати = "Документ.РасходныйОрдерНаТовары";
		КомандаПечати.Идентификатор = "РасходныйОрдерНаТовары";
		КомандаПечати.Представление = НСтр("ru = 'Расходный ордер на товары';
											|en = 'Goods issue'");
		КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
		КомандаПечати.МестоРазмещения = "ОрдераВРаботеГруппаКоманднаяПанель";
	КонецЕсли;

	// Задание на отбор товаров
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Обработка.ПечатьЗаданияНаОтборРазмещениеТоваров";
	КомандаПечати.Идентификатор = "ЗаданиеНаОтборРазмещениеТовара";
	КомандаПечати.Представление = НСтр("ru = 'Задание на отбор товаров';
										|en = 'Picking job'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.ДополнительныеПараметры.Вставить("ИмяФормы", "ЗаданиеНаОтбор");
	КомандаПечати.МестоРазмещения = "ОрдераВРаботеГруппаКоманднаяПанель";
	
	Если ПравоДоступа("Изменение", Метаданные.Документы.ОрдерНаПеремещениеТоваров) Тогда
		// Ордер на перемещение товаров
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.МенеджерПечати = "Документ.ОрдерНаПеремещениеТоваров";
		КомандаПечати.Идентификатор = "ОрдерНаПеремещениеТоваров";
		КомандаПечати.Представление = НСтр("ru = 'Ордер на перемещение товаров';
											|en = 'Internal stock transfer'");
		КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
		КомандаПечати.МестоРазмещения = "ОрдераВРаботеГруппаКоманднаяПанель";
	КонецЕсли;
	
КонецПроцедуры

#Область ТекущиеДела

// Заполняет список текущих дел пользователя.
// 
// Параметры:
// 	ТекущиеДела - см. ТекущиеДелаСервер.ТекущиеДела
//
Процедура ПриЗаполненииСпискаТекущихДел(ТекущиеДела) Экспорт
	
	ИмяФормы = "Обработка.УправлениеОтгрузкой.Форма.Форма";
	
	ОбщиеПараметрыЗапросов = ТекущиеДелаСлужебный.ОбщиеПараметрыЗапросов();
	
	// Определим доступны ли текущему пользователю показатели группы
	Доступность =
		(ОбщиеПараметрыЗапросов.ЭтоПолноправныйПользователь
			Или ПравоДоступа("Просмотр", Метаданные.Обработки.УправлениеОтгрузкой))
		И ПолучитьФункциональнуюОпцию("ИспользоватьОрдернуюСхемуПриОтгрузке");
	
	Если НЕ Доступность Тогда
		Возврат;
	КонецЕсли;
	
	// Расчет показателей
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ РегистрНакопленияТоварыКОтгрузкеОстатки.ДокументОтгрузки) КАК ЗначениеПоказателя,
	|	РегистрНакопленияТоварыКОтгрузкеОстатки.Склад КАК Склад
	|ИЗ
	|	РегистрНакопления.ТоварыКОтгрузке.Остатки(&ДатаОтгрузки, Склад.ИспользоватьОрдернуюСхемуПриОтгрузке) КАК РегистрНакопленияТоварыКОтгрузкеОстатки
	|
	|СГРУППИРОВАТЬ ПО
	|	РегистрНакопленияТоварыКОтгрузкеОстатки.Склад";
	
	ТекущиеДелаСлужебный.УстановитьОбщиеПараметрыЗапросов(Запрос, ОбщиеПараметрыЗапросов);
	
	Запрос.УстановитьПараметр("ДатаОтгрузки", КонецДня(ОбщиеПараметрыЗапросов.ТекущаяДата));
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	// Заполнение дел.
	// РаспоряженияНаПоступление
	ДелоРодитель = ТекущиеДела.Добавить();
	ДелоРодитель.Идентификатор  = "РаспоряженияНаОтгрузку";
	ДелоРодитель.Представление  = НСтр("ru = 'Распоряжения на отгрузку';
										|en = 'Shipment references'");
	ДелоРодитель.Владелец       = Метаданные.Подсистемы.Склад;
	
	Для Каждого СтрокаРезультата Из Результат Цикл
		
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("Помещение", Неопределено);
		ПараметрыОтбора.Вставить("ЗонаОтгрузки", Неопределено);
		
		ПредставлениеДела = "";
		ИдентификаторДела = "";
		ЗначениеДела      = 0;
		Для Каждого КолонкаРезультата Из Результат.Колонки Цикл
			ЗначениеКолонки = СтрокаРезультата[КолонкаРезультата.Имя];
			Если КолонкаРезультата.Имя = "ЗначениеПоказателя" Тогда
				ЗначениеДела = ЗначениеКолонки;
				Продолжить;
			КонецЕсли;
			ПредставлениеДела = ?(ПредставлениеДела = "", "", ", ") + Строка(ЗначениеКолонки);
			ИдентификаторДела = ?(ИдентификаторДела = "", ДелоРодитель.Идентификатор, ИдентификаторДела)
				+ СтрЗаменить(Строка(ЗначениеКолонки), " ", "");
			ПараметрыОтбора.Вставить(КолонкаРезультата.Имя, ЗначениеКолонки);
		КонецЦикла;
		
		Дело = ТекущиеДела.Добавить();
		Дело.Идентификатор  = ИдентификаторДела;
		Дело.ЕстьДела       = ЗначениеДела > 0;
		Дело.Представление  = ПредставлениеДела;
		Дело.Количество     = ЗначениеДела;
		Дело.Важное         = Ложь;
		Дело.Форма          = ИмяФормы;
		Дело.ПараметрыФормы = Новый Структура("СтруктураБыстрогоОтбора", ПараметрыОтбора);
		Дело.Владелец       = "РаспоряженияНаОтгрузку";
		
		Если ЗначениеДела > 0 Тогда
			ДелоРодитель.ЕстьДела = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
