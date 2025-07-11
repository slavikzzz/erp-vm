// "@strict-types"

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область Печать

// Сформировать печатные формы объектов.
//
// Параметры:
//   МассивОбъектов        - Массив из Произвольный         - ссылки на объекты, которые нужно распечатать
//   ПараметрыПечати       - Структура                      - дополнительные настройки печати
//   КоллекцияПечатныхФорм - ТаблицаЗначений                - сформированные табличные документы (выходной параметр)
//   ОбъектыПечати         - СписокЗначений из Произвольный - имя области, в которой был выведен объект (выходной параметр)
//   ПараметрыВывода       - Структура                      - дополнительные параметры сформированных табличных документов (выходной параметр)
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СДИЗРасширеннаяЭтикетка") Тогда
		СтруктураТипов = ИнтеграцияИС.СоответствиеМассивовПоТипамОбъектов(МассивОбъектов);
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"СДИЗРасширеннаяЭтикетка",
			НСтр("ru = 'СДИЗ, расширенная этикетка';
				|en = 'СДИЗ, расширенная этикетка'"),
			СформироватьПечатнуюФормуСДИЗРасширеннаяЭтикетка(СтруктураТипов, ОбъектыПечати, ПараметрыПечати));
	КонецЕсли;
	
	ИнтеграцияИСПереопределяемый.ЗаполнитьПараметрыОтправки(ПараметрыВывода.ПараметрыОтправки, МассивОбъектов, КоллекцияПечатныхФорм);
	
КонецПроцедуры

#КонецОбласти

#Область ЭтикеткиСДИЗ

Функция СформироватьПечатнуюФормуСДИЗРасширеннаяЭтикетка(СтруктураТипов, ОбъектыПечати, ПараметрыПечати) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_СДИЗ_РАСШИРЕННАЯЭТИКЕТКА";
	
	НомерТипаДокумента = 0;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Для Каждого СтруктураОбъектов Из СтруктураТипов Цикл
		
		НомерТипаДокумента = НомерТипаДокумента + 1;
		Если НомерТипаДокумента > 1 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(СтруктураОбъектов.Ключ);
		ДанныеДляПечати = МенеджерОбъекта.ПолучитьДанныеДляПечатнойФормыРасширеннойЭтикеткиСДИЗ(ПараметрыПечати, СтруктураОбъектов.Значение);
		
		ЗаполнитьТабличныйДокументСДИЗРасширеннаяЭтикетка(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати, ПараметрыПечати);
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ЗаполненениеЭтикетокСДИЗ

Процедура ЗаполнитьТабличныйДокументСДИЗРасширеннаяЭтикетка(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати, ПараметрыПечати)
	
	ДанныеПечати = ДанныеДляПечати.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Если ДанныеПечати.Количество() = 0 Тогда	
		ОтметитьПечатьНеТребуется(ТабличныйДокумент);	
	КонецЕсли;
	
	Пока ДанныеПечати.Следующий() Цикл
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		Макет = Новый ТабличныйДокумент;
		
		ДанныеСДИЗ = ДанныеПечати.Выбрать();
		Пока ДанныеСДИЗ.Следующий() Цикл 
			ЗаполнитьРеквизитыШапкиСДИЗРасширеннаяЭтикетка(ДанныеСДИЗ, Макет, ТабличныйДокумент);
		КонецЦикла;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеПечати.Ссылка);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьРеквизитыШапкиСДИЗРасширеннаяЭтикетка(ДанныеПечати, Макет, ТабличныйДокумент)
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьЭтикетокЗЕРНО.ПФ_MXL_СДИЗРасширеннаяЭтикетка");
	
	ОбластьМакета = Макет.ПолучитьОбласть("Этикетка");
	
	ВывестиQRКод(ДанныеПечати,ОбластьМакета);
	ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
	
	ПредставлениеТовара                          = "";
	ЕдиницаИзмеренияКилограмм                    = ИнтеграцияИСКлиентСерверПовтИсп.ЕдиницаИзмеренияКилограмм();

	ОбластьМакета.Параметры.ДатаДокумента        = Формат(ДанныеПечати.ДатаДокумента,"ДЛФ=D");
	ОбластьМакета.Параметры.ЕдиницаИзмерения     = ЕдиницаИзмеренияКилограмм;
	ОбластьМакета.Параметры.ДатаПечати           = ТекущаяДатаСеанса();
	ОбластьМакета.Параметры.ТекущийПользователь  = Пользователи.АвторизованныйПользователь();
	
	РеквизитыОтправителя = РаботаСКонтрагентамиИСВызовСервера.ИННКПППоОрганизацииКонтрагенту(ДанныеПечати.Отправитель);
	РеквизитыПолучателя  = РаботаСКонтрагентамиИСВызовСервера.ИННКПППоОрганизацииКонтрагенту(ДанныеПечати.Получатель);
	
	СтруктураЗаполненияИННКПП = Новый Структура("ОтправительИНН, ПолучательИНН", РеквизитыОтправителя.ИНН, РеквизитыПолучателя.ИНН);
	ОбластьМакета.Параметры.Заполнить(СтруктураЗаполненияИННКПП);
	
	Если НЕ ЗначениеЗаполнено(ДанныеПечати.ГрузоотправительАдрес) Тогда
		ОбластьМакета.Параметры.ГрузоотправительАдрес   = "--";
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ДанныеПечати.ГрузополучательАдрес) Тогда
		ОбластьМакета.Параметры.ГрузополучательАдрес    = "--";
	КонецЕсли;
		
	Если НЕ ЗначениеЗаполнено(ДанныеПечати.Номенклатура) И ЗначениеЗаполнено(ДанныеПечати.Партия) Тогда
	
		//@skip-check wrong-string-literal-content
		ОКПД2 = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеПечати.Партия, "ОКПД2");
		
		НаименованияОКПД2 = ИнтеграцияЗЕРНО.НаименованияКодовОКПД2ПоТабличнойЧасти(ОКПД2);
		Если НаименованияОКПД2.Количество() Тогда
			ПредставлениеТовара = ИнтеграцияЗЕРНОКлиентСервер.ПредставлениеОКПД2(
				НаименованияОКПД2[0].Наименование, ОКПД2);
		КонецЕсли;
	
	Иначе
		
		ПредставлениеТовара = ОбщегоНазначенияИС.ПредставлениеНоменклатуры(
			ДанныеПечати.Номенклатура, 
			ДанныеПечати.Характеристика, 
			, 
			ДанныеПечати.Серия);	
			
	КонецЕсли;
			
	ОбластьМакета.Параметры.Продукция            = ПредставлениеТовара;		
	
	Если НЕ ТабличныйДокумент.ПроверитьВывод(ОбластьМакета)Тогда 
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
	КонецЕсли;
	
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура ВывестиQRКод(ДанныеПечати, ОбластьМакета)
	
	ШаблонQRСтрока = "url: "
		+ НСтр("ru = '%1 
                     |СДИЗ: %2
                     |Партия: %3';
                     |en = '%1 
                     |СДИЗ: %2
                     |Партия: %3'");
	
	ПутьКДаннымСДИЗ = ИнтеграцияЗЕРНОКлиентСервер.ПутьКСерверуСИнформациейПоСДИЗ(ДанныеПечати.ИдентификаторСДИЗ, ДанныеПечати.ВидПродукции);
	QRСтрока = СтрШаблон(ШаблонQRСтрока, ПутьКДаннымСДИЗ, ДанныеПечати.НомерДокумента, ДанныеПечати.НомерПартии);
	
	Эталон = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ЭталонИС");
	КоличествоМиллиметровВПикселе = Эталон.Рисунки.Квадрат100Пикселей.Высота / 100;
	
	Если Не ПустаяСтрока(QRСтрока) Тогда
		
		Рисунок = ОбластьМакета.Рисунки.QRКод;
		
		ПараметрыШтрихкода = ГенерацияШтрихкода.ПараметрыГенерацииШтрихкода();
		ПараметрыШтрихкода.Штрихкод = QRСтрока;
		ПараметрыШтрихкода.Ширина = Окр(Рисунок.Ширина / КоличествоМиллиметровВПикселе);
		ПараметрыШтрихкода.Высота = Окр(Рисунок.Высота / КоличествоМиллиметровВПикселе);
		ПараметрыШтрихкода.ТипВходныхДанных = 0; // Штрихкод - это строка
		ПараметрыШтрихкода.ТипКода = 16;
		ПараметрыШтрихкода.ОтображатьТекст = Ложь;
		ПараметрыШтрихкода.Масштабировать = Истина;
		
		РезультатГенерацииШтрихкода = ГенерацияШтрихкода.ИзображениеШтрихкода(ПараметрыШтрихкода);
		
		Если РезультатГенерацииШтрихкода.Картинка <> Неопределено Тогда
			Рисунок.Картинка = РезультатГенерацииШтрихкода.Картинка;
		Иначе
			Шаблон = Нстр("ru = 'Не удалось сформировать QR-код для документа %1.
				|Технические подробности см. в журнале регистрации.';
				|en = 'Не удалось сформировать QR-код для документа %1.
				|Технические подробности см. в журнале регистрации.'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, ДанныеПечати.Ссылка);
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОтметитьПечатьНеТребуется(ТабличныйДокумент)
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьЭтикетокЗЕРНО.ПФ_MXL_НетДанныхДляПечати");
	ТабличныйДокумент.Вывести(Макет);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли