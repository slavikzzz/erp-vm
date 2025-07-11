#Область ПрограммныйИнтерфейс

// Процедура установки типа и видимости субконто в зависимости от выбранного счета
//
// Параметры:
//	Счет			 - <План счетов> - Счет, для которого необходимо настроить тип и видимость субконто
//	Форма			 - <Управляемая форма> - Форма, которая содержит ПоляФормы и ЗаголовкиПолей
//	ПоляФормы		 - <Структура> - Ключи, которой Субконто1, Субконто2, Субконто3, 
//									 а значения имена соответствующих полей на форме (поля субконто)
//	ЗаголовкиПолей	 - <Структура> ИЛИ <Неопределено> - Ключи, которой Субконто1, Субконто2, Субконто3
//									 а значения имена соответствующих полей на форме (заголовки субконто)
//	ЭтоТаблица		 - <Булево>		 - Признак того, где выполняется настройка субконто. 
//	СкрыватьСубконто - <Булево>		 - Признак того, нужно ли для этой формы дополнительно скрывать субконто, влияет на выполнении функции НужноСкрытьСубконто
//
Процедура ПриВыбореСчета(Счет, Форма, ПоляФормы, ЗаголовкиПолей = Неопределено, ЭтоТаблица = Ложь, СкрыватьСубконто = Истина) Экспорт
	
	ДанныеСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Счет);
	
	Для Индекс = 1 По 3 Цикл
		ТипЗначенияСубконто = ДанныеСчета["ВидСубконто" + Индекс + "ТипЗначения"];
		Если Индекс <= ДанныеСчета.КоличествоСубконто И НЕ НужноСкрытьСубконто(СкрыватьСубконто, ТипЗначенияСубконто) Тогда
			Если ЭтоТаблица Тогда
				Если ПоляФормы.Свойство("Субконто" + Индекс) Тогда
					Форма.Элементы[ПоляФормы["Субконто" + Индекс]].ОграничениеТипа = ТипЗначенияСубконто;
					Форма.Элементы[ПоляФормы["Субконто" + Индекс]].ПодсказкаВвода  = ДанныеСчета["ВидСубконто" + Индекс + "Наименование"];
				КонецЕсли;
			Иначе
				Если ЗаголовкиПолей <> Неопределено И ЗаголовкиПолей.Свойство("Субконто" + Индекс) Тогда
					// Заголовок может быть не выведен на форму
					ЭлементФормыЗаголовок = Форма.Элементы.Найти(ЗаголовкиПолей["Субконто" + Индекс]);
					Если ЭлементФормыЗаголовок <> Неопределено Тогда
						ЭлементФормыЗаголовок.Видимость = Истина;
					КонецЕсли;
					Форма[ЗаголовкиПолей["Субконто" + Индекс]] = ДанныеСчета["ВидСубконто" + Индекс + "Наименование"] + ":";
				КонецЕсли;
				Если ПоляФормы.Свойство("Субконто" + Индекс) Тогда
					Форма.Элементы[ПоляФормы["Субконто" + Индекс]].Видимость       = Истина;
					Форма.Элементы[ПоляФормы["Субконто" + Индекс]].ОграничениеТипа = ТипЗначенияСубконто;
				КонецЕсли;
			КонецЕсли;
		Иначе 
			// Ничего делать не надо, т.к. не доступные поля будут скрыты
			Если Не ЭтоТаблица Тогда
				Если ЗаголовкиПолей <> Неопределено И ЗаголовкиПолей.Свойство("Субконто" + Индекс) Тогда
					// Заголовок может быть не выведен на форму
					ЭлементФормыЗаголовок = Форма.Элементы.Найти(ЗаголовкиПолей["Субконто" + Индекс]);
					Если ЭлементФормыЗаголовок <> Неопределено Тогда
						ЭлементФормыЗаголовок.Видимость	 = Ложь;
					КонецЕсли;
					Форма[ЗаголовкиПолей["Субконто" + Индекс]] = "";
				КонецЕсли;
				Если ПоляФормы.Свойство("Субконто" + Индекс) Тогда
					Форма.Элементы[ПоляФормы["Субконто" + Индекс]].Видимость       = Ложь;
					Форма.Элементы[ПоляФормы["Субконто" + Индекс]].ОграничениеТипа = Новый ОписаниеТипов("Неопределено");
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ЭтоТаблица Тогда
		Если ЗаголовкиПолей <> Неопределено И ЗаголовкиПолей.Свойство("Подразделение") Тогда
			Форма[ЗаголовкиПолей["Подразделение"]] = ?(ДанныеСчета.УчетПоПодразделениям, НСтр("ru = 'Подразделение';
																								|en = 'Business unit'") + ":", "");
		КонецЕсли;
		Если ПоляФормы.Свойство("Подразделение") Тогда
			
			ДоступностьПодразделения = ДанныеСчета.УчетПоПодразделениям;
			Если ПоляФормы.Свойство("ДоступностьПодразделения") Тогда
				ДоступностьПодразделения = ДоступностьПодразделения ИЛИ ПоляФормы.ДоступностьПодразделения;
			КонецЕсли;
			
			Форма.Элементы[ПоляФормы["Подразделение"]].Доступность = ДоступностьПодразделения;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Процедура установки типа, значения и доступности субконто в зависимости от выбранного счета.
//
// Параметры:
//	Счет			 - ПланСчетовСсылка.Хозрасчетный - Счет, для которого необходимо настроить тип и видимость субконто.
//	Объект			 - УправляемаяФорма, СтрокаТабличнойЧасти - Объект, который содержит ПоляФормы.
//	ПоляОбъекта		 - Структура - Ключи, которой Субконто1, Субконто2, Субконто3, 
//									 а значения имена соответствующих полей на форме (поля субконто).
//	ЭтоТаблица       - Булево  - Признак того, что Объект является таблицей.
//	ЗначенияСубконто - Соответствие, Неопределено - Значения субконто, где ключ Вид субконто, а значение - значение для подстановки.
//	СкрыватьСубконто - Булево  - Признак того, нужно ли для этой формы дополнительно скрывать субконто, влияет на выполнении функции СкрытьСубконто.
//
Процедура ПриИзмененииСчета(Счет, Объект, ПоляОбъекта, ЭтоТаблица = Ложь, ЗначенияСубконто = Неопределено, СкрыватьСубконто = Истина) Экспорт
	
	ДанныеСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Счет);
	Для Индекс = 1 По 3 Цикл
		Если ПоляОбъекта.Свойство("Субконто" + Индекс) Тогда
			Если Индекс <= ДанныеСчета.КоличествоСубконто Тогда
				ТипЗначенияСубконто = ДанныеСчета["ВидСубконто" + Индекс + "ТипЗначения"];
				ЗначениеСубконто = ТипЗначенияСубконто.ПривестиЗначение(Объект[ПоляОбъекта["Субконто" + Индекс]]);
				ЗначениеСубконтоПоУмолчанию = ?(ЗначенияСубконто = Неопределено, ЗначенияСубконто, ЗначенияСубконто.Получить(ДанныеСчета["ВидСубконто" + Индекс]));
				Если ЗначениеЗаполнено(ЗначениеСубконто) ИЛИ (НЕ ЗначениеЗаполнено(ЗначениеСубконтоПоУмолчанию)) Тогда
					Объект[ПоляОбъекта["Субконто" + Индекс]] = ЗначениеСубконто;
				Иначе
					Объект[ПоляОбъекта["Субконто" + Индекс]] = ЗначениеСубконтоПоУмолчанию;
				КонецЕсли;
			Иначе 
				Объект[ПоляОбъекта["Субконто" + Индекс]] = Неопределено;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если ЭтоТаблица Тогда
		УстановитьДоступностьСубконто(Счет, Объект, ПоляОбъекта, СкрыватьСубконто);
	КонецЕсли;
	
	Если ПоляОбъекта.Свойство("Подразделение") Тогда
		Если ДанныеСчета.УчетПоПодразделениям Тогда
			ПодразделениеПоУмолчанию = Неопределено;
			ПоляОбъекта.Свойство("ПодразделениеПоУмолчанию", ПодразделениеПоУмолчанию);
			НовоеПодразделение = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьПодразделениеПриИзмененииСчета(
				Объект[ПоляОбъекта.Подразделение],
				ПоляОбъекта.Организация,
				ПодразделениеПоУмолчанию);
			
			Если НовоеПодразделение <> Объект[ПоляОбъекта.Подразделение] Тогда
				Объект[ПоляОбъекта.Подразделение] = НовоеПодразделение;
			КонецЕсли;
			
			Если ЭтоТаблица Тогда
				Объект[ПоляОбъекта["Подразделение"] + "Доступность"] = Истина;
			КонецЕсли;
		Иначе
			Объект[ПоляОбъекта.Подразделение] = Неопределено;
			Если ЭтоТаблица Тогда
				Объект[ПоляОбъекта["Подразделение"] + "Доступность"] = Ложь;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Процедура установки доступности субконто в зависимости от выбранного счета.
//
// Параметры:
//	Счет			 - ПланСчетовСсылка.Хозрасчетный - Счет, для которого необходимо настроить тип и видимость субконто.
//	Объект			 - УправляемаяФорма, СтрокаТабличнойЧасти - Объект, который содержит ПоляФормы.
//	ПоляОбъекта		 - Структура - Ключи, которой Субконто1, Субконто2, Субконто3, а значения имена соответствующих полей на форме (поля субконто).
//	СкрыватьСубконто - Булево - Признак того, нужно ли для этой формы дополнительно скрывать субконто, влияет на выполнении функции НужноСкрытьСубконто.
//
Процедура УстановитьДоступностьСубконто(Счет, Объект, ПоляОбъекта, СкрыватьСубконто = Истина) Экспорт
	
	ДанныеСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Счет);
	
	Для Индекс = 1 По 3 Цикл
		Если ПоляОбъекта.Свойство("Субконто" + Индекс) Тогда
			ТипЗначенияСубконто = ДанныеСчета["ВидСубконто" + Индекс + "ТипЗначения"];
			Если НужноСкрытьСубконто(СкрыватьСубконто, ТипЗначенияСубконто) Тогда
				Объект[ПоляОбъекта["Субконто" + Индекс] + "Доступность"] = Ложь;
			Иначе
				Объект[ПоляОбъекта["Субконто" + Индекс] + "Доступность"] = (Индекс <= ДанныеСчета.КоличествоСубконто);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если ПоляОбъекта.Свойство("Подразделение") Тогда
		Объект[ПоляОбъекта["Подразделение"] + "Доступность"] = ДанныеСчета.УчетПоПодразделениям;
	КонецЕсли;
	
	Если ПоляОбъекта.Свойство("Валютный") Тогда
		Объект[ПоляОбъекта["Валютный"] + "Доступность"] = ДанныеСчета.Валютный;
	КонецЕсли;
	
	Если ПоляОбъекта.Свойство("Количественный") Тогда
		Объект[ПоляОбъекта["Количественный"] + "Доступность"] = ДанныеСчета.Количественный;
	КонецЕсли;
	
КонецПроцедуры

// Процедура изменяет параметры выбора полей субконто.
//
// Параметры:
//	Форма - УправляемаяФорма - Форма, на которой расположены поля субконто.
//	Объект - ДанныеФормыСтруктура - Объект, форма которого отображается.
//	ШаблонИмяПоляОбъекта - Строка - Шаблон имени поля объекта, содержащего субконто.
//	ШаблонИмяЭлементаФормы - Строка - Шаблон имени поля формы, в который выводится субконто.
//	СписокПараметров - Структура - Содержит ключи со значениями отборов.
//
Процедура ИзменитьПараметрыВыбораПолейСубконто(Форма, Объект, ШаблонИмяПоляОбъекта, ШаблонИмяЭлементаФормы, СписокПараметров) Экспорт
	
	ВидыПараметров = Новый Соответствие;
	ВидыПараметров.Вставить(БухгалтерскийУчетКлиентСерверПереопределяемый.ТипЗначенияБанковскогоСчетаОрганизации(), "БанковскийСчет");
	ВидыПараметров.Вставить(БухгалтерскийУчетКлиентСерверПереопределяемый.ТипПодразделения(), "Подразделение");
	Для каждого ТипДоговора Из БухгалтерскийУчетКлиентСерверПереопределяемый.ПолучитьОписаниеТиповДоговора().Типы() Цикл
		ВидыПараметров.Вставить(ТипДоговора, "Договор");
	КонецЦикла;
	ВидыПараметров.Вставить(Тип("СправочникСсылка.РегистрацииВНалоговомОргане"), "РегистрацияВИФНС");
	ВидыПараметров.Вставить(Тип("СправочникСсылка.Субконто"), "Субконто");
	
	ОчищатьСвязанныеСубконто = Ложь;
	ТипыСвязанныхСубконто    = Неопределено;
	Если ТипЗнч(Форма.ТекущийЭлемент) = Тип("ТаблицаФормы") Тогда
		ТекущийЭлемент = Форма.ТекущийЭлемент.ТекущийЭлемент;
	Иначе
		ТекущийЭлемент = Форма.ТекущийЭлемент;
	КонецЕсли;
	ИмяТекущегоЭлемента = ?(ТипЗнч(ТекущийЭлемент) = Тип("ПолеФормы"), ТекущийЭлемент.Имя, "");
	
	Для Индекс = 1 По 3 Цикл
		ИмяЭлементаФормы = СтрЗаменить(ШаблонИмяЭлементаФормы, "%Индекс%", Индекс);
		ИмяПоляОбъекта   = СтрЗаменить(ШаблонИмяПоляОбъекта  , "%Индекс%", Индекс);
		ТипПоляОбъекта   = ТипЗнч(Объект[ИмяПоляОбъекта]);

		МассивПараметров = Новый Массив();
		
		ВидПараметра = ВидыПараметров[ТипПоляОбъекта];
		
		Если ВидПараметра <> Неопределено Тогда
			
			Если ВидПараметра = "Договор" Тогда
				Если СписокПараметров.Свойство("Организация") Тогда
					ИменаОрганизаций = БухгалтерскийУчетКлиентСерверПереопределяемый.ПолучитьИменаРеквизитовОрганизацияДоговора(ТипПоляОбъекта);
					Для каждого ИмяОрганизации Из ИменаОрганизаций Цикл
						МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор." + ИмяОрганизации, СписокПараметров.Организация));
					КонецЦикла;
				КонецЕсли;
				Если СписокПараметров.Свойство("Контрагент") Тогда
					ИмяКонтрагента = БухгалтерскийУчетКлиентСерверПереопределяемый.ПолучитьИмяРеквизитаКонтрагентДоговора();
					МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор." + ИмяКонтрагента, СписокПараметров.Контрагент));
				КонецЕсли;
			ИначеЕсли ВидПараметра = "БанковскийСчет" Тогда
				МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Владелец", СписокПараметров.Организация));
			ИначеЕсли ВидПараметра = "РегистрацияВИФНС" Тогда
				ГоловнаяОрганизация = ОбщегоНазначенияБПВызовСервераПовтИсп.ГоловнаяОрганизация(СписокПараметров.Организация);
				МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Владелец", ГоловнаяОрганизация));
			ИначеЕсли ВидПараметра = "Субконто"
				И СписокПараметров.Свойство("СчетУчета") Тогда
				СвойстваСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(СписокПараметров.СчетУчета);
				МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Владелец", СвойстваСчета["ВидСубконто" + Индекс]));
			ИначеЕсли ВидПараметра = "Подразделение" Тогда
				ИмяРеквизитаОрганизация = БухгалтерскийУчетКлиентСерверПереопределяемый.ИмяРеквизитаОрганизацияПодразделения();
				Если ЗначениеЗаполнено(ИмяРеквизитаОрганизация) Тогда
					МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор." + ИмяРеквизитаОрганизация, СписокПараметров.Организация));
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;

		БухгалтерскийУчетКлиентСерверПереопределяемый.ДополнитьПараметрыВыбора(ТипПоляОбъекта, СписокПараметров, МассивПараметров);
			
		Если МассивПараметров.Количество() > 0 Тогда
			ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
			Форма.Элементы[ИмяЭлементаФормы].ПараметрыВыбора = ПараметрыВыбора;
		КонецЕсли;
		
		Если ОчищатьСвязанныеСубконто 
			И ЗначениеЗаполнено(Объект[ИмяПоляОбъекта]) Тогда
		
			Если ТипыСвязанныхСубконто = Неопределено Тогда
				ВсеТипыСвязанныхСубконто = БухгалтерскийУчетВызовСервераПовтИсп.ВсеТипыСвязанныхСубконто();
				ТипыСвязанныхСубконто    = Новый ОписаниеТипов(Новый Массив);
				Для каждого Параметр Из СписокПараметров Цикл
					Если ВсеТипыСвязанныхСубконто[Параметр.Ключ] <> Неопределено Тогда
						ТипыСвязанныхСубконто = Новый ОписаниеТипов(ТипыСвязанныхСубконто, 
							ВсеТипыСвязанныхСубконто[Параметр.Ключ].Типы());
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
			
			Если ТипыСвязанныхСубконто.СодержитТип(ТипПоляОбъекта) Тогда
				Объект[ИмяПоляОбъекта] = Новый (ТипПоляОбъекта);
			КонецЕсли;
		
		КонецЕсли;
		
		Если ИмяТекущегоЭлемента = ИмяЭлементаФормы Тогда
			ОчищатьСвязанныеСубконто = Истина; // Очищаются только субконто с номером больше текущего
		КонецЕсли;
			
	КонецЦикла;

КонецПроцедуры

// Процедура изменяет параметры выбора для ПоляВвода управляемой формы.
//
// Параметры:
//	ЭлементФормыСчет - ПолеВвода - Поле, для которого изменяется параметр выбора.
//  МассивСчетов                 - Массив, Неопределено - счета, которыми нужно ограничить список. 
//	                                   Если не заполнено - ограничения не будет.
//  ОтборПоПризнакуВалютный      - Булево, Неопределено - Значение для установки соответствующего параметра выбора. 
//                                     Если неопределено, параметр выбора не устанавливается.
//  ОтборПоПризнакуЗабалансовый   - Булево, Неопределено - Значение для установки соответствующего параметра выбора. 
//                                     Если неопределено, параметр выбора не устанавливается.
//  ОтборПоПризнакуСчетГруппа    - Булево, Неопределено - Значение для установки соответствующего параметра выбора. 
//                                     Если неопределено, параметр выбора не устанавливается.
//
Процедура ИзменитьПараметрыВыбораСчета(ЭлементФормыСчет, МассивСчетов, ОтборПоПризнакуВалютный = Неопределено, ОтборПоПризнакуЗабалансовый = Неопределено, ОтборПоПризнакуСчетГруппа = Ложь) Экспорт

	МассивОтборов = Новый Массив;
	Если ОтборПоПризнакуСчетГруппа <> Неопределено Тогда
		МассивОтборов.Добавить(Новый ПараметрВыбора("Отбор.ЗапретитьИспользоватьВПроводках", ОтборПоПризнакуСчетГруппа));
	КонецЕсли; 
	
	Если ОтборПоПризнакуВалютный <> Неопределено Тогда
		МассивОтборов.Добавить(Новый ПараметрВыбора("Отбор.Валютный", ОтборПоПризнакуВалютный));
	КонецЕсли; 
	
	Если ОтборПоПризнакуЗабалансовый <> Неопределено Тогда
		МассивОтборов.Добавить(Новый ПараметрВыбора("Отбор.Забалансовый", ОтборПоПризнакуЗабалансовый));
	КонецЕсли; 
	
	Если МассивСчетов <> Неопределено И МассивСчетов.Количество() > 0 Тогда
		МассивОтборов.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(МассивСчетов)));
	КонецЕсли; 

	ПараметрыВыбора = Новый ФиксированныйМассив(МассивОтборов);
	ЭлементФормыСчет.ПараметрыВыбора = ПараметрыВыбора;
	
КонецПроцедуры

// Возвращает описание типов для суммового показателя.
//
// Возвращаемое значение:
//	ОписаниеТипов - Описание типов для суммового показателя.
//
Функция ТипСумма() Экспорт
	
	Возврат Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, РазрядностьДробнойЧастиСумм()));
	
КонецФункции

// Возвращает число знаков после запятой для суммового показателя.
//
// Возвращаемое значение:
//	Число - число знаков после запятой для суммового показателя.
//
Функция РазрядностьДробнойЧастиСумм() Экспорт
	
	Возврат 2;
	
КонецФункции

// Проверяет условие использования сумм НУ.
//
// Параметры:
//  ВидИспользованияСумм - Строка - см. БухгалтерскийУчетВызовСервераПовтИсп.ПользователюДоступныСуммыНалогНаПрибыль()
//
// Возвращаемое значение:
//   Булево      - Истина, если суммы НУ используются.
//
Функция ИспользоватьСуммуНУ(ВидИспользованияСумм) Экспорт
	
	Возврат ВидИспользованияСумм <> "НеИспользовать";
	
КонецФункции

// Проверяет условие использования сумм ВР и ПР.
//
// Параметры:
//  ВидИспользованияСумм - Строка - см. БухгалтерскийУчетВызовСервераПовтИсп.ПользователюДоступныСуммыНалогНаПрибыль()
//
// Возвращаемое значение:
//   Булево      - Истина, если суммы разниц используются.
//
Функция ИспользоватьСуммыРазниц(ВидИспользованияСумм) Экспорт
	
	Возврат ВидИспользованияСумм = "ПоддержкаПБУ18";
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция определяет, нужно ли скрывать данное субконто.
//
// Параметры:
//	СкрыватьСубконто - Булево - Признак того, нужно ли для этой формы дополнительно скрывать субконто.
//	ТипЗначенияСубконто - Описание типов.
//
Функция НужноСкрытьСубконто(СкрыватьСубконто, ТипЗначенияСубконто)
	
	// В БРУ / УП вид субконто номенклатурные группы не скрываются.
	Возврат Ложь;

КонецФункции

#КонецОбласти