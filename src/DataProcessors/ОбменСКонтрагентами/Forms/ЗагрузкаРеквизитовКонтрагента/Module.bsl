
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Контрагент = Параметры.Контрагент;
	
	Если ЗначениеЗаполнено(Контрагент) Тогда
		ОткрытаФормаЭлемента = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Загрузить(Команда)
	
	Если ЗаполненыОбязательныеРеквизиты() Тогда
		Если ЗначениеЗаполнено(Контрагент) Тогда
			ТекстВопроса = НСтр("ru = 'Контрагент существует. Перезаполнить реквизиты?';
								|en = 'Counterparty exists. Fill in the attributes again?'");
			ОписаниеОповещения = Новый ОписаниеОповещения("ЗакончитьЗагрузку", ЭтотОбъект);
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	АдресВХранилище = Неопределено;
	Обработчик = Новый ОписаниеОповещения("ФайлОбработкаВыбора", ЭтотОбъект);
	НачатьПомещениеФайла(Обработчик, АдресВХранилище, , Истина, УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура РазобратьФайлНаСервере();
	
	ОбъектXML = Новый ЧтениеXML;
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресВХранилище);
	
	ВремФайл = РаботаСФайламиБЭД.ТекущееИмяВременногоФайла("xml");
	ДвоичныеДанные.Записать(ВремФайл);
	
	Попытка
		ОбъектXML.ОткрытьФайл(ВремФайл);
		ЭД = ФабрикаXDTO.ПрочитатьXML(ОбъектXML);
	Исключение
		ОбъектXML.Закрыть();
		ШаблонСообщения = НСтр("ru = 'Возникла ошибка при чтении данных из файла %1: %2.';
								|en = 'An error occurred while reading data from file %1: %2.'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения,
			ВремФайл, ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЭлектронноеВзаимодействие.ОбработатьОшибку(НСтр("ru = 'Чтение ЭД.';
														|en = 'ED reading'"),
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),
			ТекстСообщения);
		Возврат;
	КонецПопытки;

	ОбъектXML.Закрыть();
	РаботаСФайламиБЭД.УдалитьВременныеФайлы(ВремФайл);
	Если НЕ ЭД.Тип() = РаботаСФайламиБЭД.ПолучитьТипЗначенияCML("Контрагент") Тогда
		Возврат;
	КонецЕсли;
	
	ДопустимыеТипы = "Страна, Регион, Район, Город, Улица, Дом, Корпус, Квартира";
	
	СвойствоЭД = ЭД.Свойства().Получить("РасчетныеСчета");
	Если СвойствоЭД <> Неопределено Тогда
		ЗначениеXDTO = ЭД.Получить(СвойствоЭД);
		Если ЗначениеXDTO <> Неопределено Тогда
			Для Каждого ТекСв Из ЗначениеXDTO.РасчетныйСчет Цикл
				РасчетныйСчет         = ТекСв.НомерСчета;
				БИК                   = ТекСв.Банк.БИК;
				КорреспондентскийСчет = ТекСв.Банк.СчетКорреспондентский;
				Банк                  = ТекСв.Банк.Наименование;
				
				Если НЕ ТекСв.БанкКорреспондент=Неопределено Тогда
					БИКБанкаДляРасчетов                       = ТекСв.БанкКорреспондент.БИК;
					КоррСчетБанкаДляРасчетов                  = ТекСв.БанкКорреспондент.СчетКорреспондентский;
					ПредставлениеБанкаДляРасчетов             = ТекСв.БанкКорреспондент.Наименование;
					Элементы.ГруппаНепрямыхРасчетов.Видимость = Истина;
				КонецЕсли;
			КонецЦикла
		КонецЕсли;
	КонецЕсли;
	
	СвойствоЭД = ЭД.Свойства().Получить("ЮрЛицо");
	Если СвойствоЭД <> Неопределено Тогда
		
		ЗначениеXDTO = ЭД.Получить(СвойствоЭД);
		Если ЗначениеXDTO <> Неопределено Тогда
			СвойствоИНН = ЗначениеXDTO.Свойства().Получить("ИНН");
			Если СвойствоИНН <> Неопределено Тогда
				ИНН = ЗначениеXDTO.Получить(СвойствоИНН);
			КонецЕсли;
			СвойствоКПП = ЗначениеXDTO.Свойства().Получить("КПП");
			Если СвойствоКПП <> Неопределено Тогда
				КПП = ЗначениеXDTO.Получить(СвойствоКПП);
			КонецЕсли;
			СвойствоОКПО = ЗначениеXDTO.Свойства().Получить("ОКПО");
			Если СвойствоОКПО <> Неопределено Тогда
				ОКПО = ЗначениеXDTO.Получить(СвойствоОКПО);
			КонецЕсли;
			НаименованиеXDTO = ЗначениеXDTO.Свойства().Получить("ОфициальноеНаименование");
			Если НаименованиеXDTO <> Неопределено Тогда
				Наименование = ЗначениеXDTO.Получить(НаименованиеXDTO);
			КонецЕсли;
			
			СвойствоРуководитель = ЗначениеXDTO.Свойства().Получить("Руководитель");
			Если СвойствоРуководитель <> Неопределено Тогда
				ЗнРуководитель = ЗначениеXDTO.Получить(СвойствоРуководитель);
				Если ЗнРуководитель <> Неопределено Тогда
					СвойствоФизЛицо = ЗнРуководитель.Свойства().Получить("ФизЛицо");
					Если СвойствоФизЛицо <> Неопределено Тогда
						ЗнФизЛицо = ЗнРуководитель.Получить(СвойствоФизЛицо);
						Если ЗнФизЛицо <> Неопределено Тогда
							ДолжностьРуководителя = ЗнФизЛицо.Должность;
							Руководитель = ЗнФизЛицо.ПолноеНаименование;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			
			СвойствоАдрес = ЗначениеXDTO.Свойства().Получить("ЮридическийАдрес");
			Если СвойствоАдрес <> Неопределено Тогда
				ЗначениеАдрес = ЗначениеXDTO.Получить(СвойствоАдрес);
				Если ЗначениеАдрес <> Неопределено Тогда
					ЮридическийАдрес = ЗначениеАдрес.Представление;
					Для Каждого ТекСв Из ЗначениеАдрес.АдресноеПоле Цикл
						Если ТекСв.Тип = "Почтовый индекс" Тогда
							ЗначенияПолейЮридическийАдрес = ЗначенияПолейФактАдрес + "Индекс" + "=" + ТекСв.Значение + Символы.ПС;
						ИначеЕсли	ТекСв.Тип = "Населенный пункт" Тогда
							ЗначенияПолейЮридическийАдрес = ЗначенияПолейФактАдрес + "НаселенныйПункт" + "=" + ТекСв.Значение + Символы.ПС;
						ИначеЕсли СтрНайти(ДопустимыеТипы, ТекСв.Тип)>0 Тогда
							ЗначенияПолейЮридическийАдрес = ЗначенияПолейФактАдрес + ТекСв.Тип + "=" + ТекСв.Значение + Символы.ПС;
						КонецЕсли;
					КонецЦикла;
				КонецЕсли
			КонецЕсли;
			
		КонецЕсли
	КонецЕсли;
		
	СвойствоЭД = ЭД.Свойства().Получить("Контакты");
	Если СвойствоЭД <> Неопределено Тогда
		ЗначениеXDTO =  ЭД.Получить(СвойствоЭД);
		Если ЗначениеXDTO <> Неопределено Тогда
			Для Каждого ТекКонтакт Из ЭД.Контакты.Контакт Цикл
				Если ТекКонтакт.Тип = "Телефон рабочий" Тогда
					Телефон = ТекКонтакт.Значение;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	СвойствоЭД = ЭД.Свойства().Получить("Адрес");
	Если СвойствоЭД <> Неопределено Тогда
		ЗначениеXDTO = ЭД.Получить(СвойствоЭД);
		Если ЗначениеXDTO <> Неопределено Тогда
			ФактическийАдрес = ЗначениеXDTO.Представление;
			Для Каждого ТекСв Из ЗначениеXDTO.АдресноеПоле Цикл
				Если ТекСв.Тип = "Почтовый индекс" Тогда
					ЗначенияПолейФактАдрес = ЗначенияПолейФактАдрес + "Индекс" + "=" + ТекСв.Значение + Символы.ПС;
				ИначеЕсли ТекСв.Тип = "Населенный пункт" Тогда
					ЗначенияПолейФактАдрес = ЗначенияПолейФактАдрес + "НаселенныйПункт" + "=" + ТекСв.Значение + Символы.ПС;
				ИначеЕсли СтрНайти(ДопустимыеТипы, ТекСв.Тип)>0 Тогда
					ЗначенияПолейФактАдрес = ЗначенияПолейФактАдрес + ТекСв.Тип + "=" + ТекСв.Значение + Символы.ПС;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;

	ИНН_КПП = "" +  ИНН + "/" + КПП;

	Если Не ЗначениеЗаполнено(Контрагент) Тогда
		ОпределитьКонтрагента();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ЗаполненыОбязательныеРеквизиты()
	
	ОчиститьСообщения();
	РеквизитыЗаполнены = Истина;
	Если НЕ ЗначениеЗаполнено(Наименование) Тогда
		РеквизитыЗаполнены = Ложь;
		ТекстСообщения = НСтр("ru = 'Не заполнено <Наименование>, загрузка не возможна.';
								|en = '<Name> is not filled, import is impossible.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		ТекстСообщения = НСтр("ru = 'Проверьте правильность указания <Файла> с реквизитами контрагента.';
								|en = 'Verify the correctness of the <File> specification with the counterparty attributes.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
	Возврат РеквизитыЗаполнены;
	
КонецФункции

&НаКлиенте
Процедура ОчиститьФорму()
	
	Наименование = "";
	ИНН_КПП = "";
	ОКПО = "";
	ДолжностьРуководителя="";
	Руководитель="";
	ЮридическийАдрес="";
	ФактическийАдрес="";
	Телефон="";
	Банк="";
	РасчетныйСчет="";
	КорреспондентскийСчет="";
	БИК="";
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыКонтрагента()
	
	СтруктураРеквизитов = Новый Структура();
	СтруктураРеквизитов.Вставить("Контрагент",             Контрагент);
	СтруктураРеквизитов.Вставить("ИНН_КПП",                ИНН_КПП);
	СтруктураРеквизитов.Вставить("ОКПО",                   ОКПО);
	СтруктураРеквизитов.Вставить("Наименование",           Наименование);
	СтруктураРеквизитов.Вставить("ЮрАдресПредставление",   ЮридическийАдрес);
	СтруктураРеквизитов.Вставить("ЮрАдресЗначенияПолей",   ЗначенияПолейЮридическийАдрес);
	СтруктураРеквизитов.Вставить("ФактАдресПредставление", ФактическийАдрес);
	СтруктураРеквизитов.Вставить("ФактАдресЗначенияПолей", ЗначенияПолейФактАдрес);
	СтруктураРеквизитов.Вставить("Телефон",                Телефон);
	СтруктураРеквизитов.Вставить("БИК",                    БИК);
	СтруктураРеквизитов.Вставить("КорреспондентскийСчет",  КорреспондентскийСчет);
	СтруктураРеквизитов.Вставить("Банк",                   Банк);
	СтруктураРеквизитов.Вставить("РасчетныйСчет",          РасчетныйСчет);
	
	ИнтеграцияЭДО.ЗаполнитьРеквизитыКонтрагента(СтруктураРеквизитов, Контрагент);
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьКонтрагента()
	
	НазваниеСправочникаКонтрагенты = ОбщегоНазначенияБЭД.ИмяПрикладногоСправочника("Контрагенты");
	Если Не ЗначениеЗаполнено(НазваниеСправочникаКонтрагенты) Тогда
		НазваниеСправочникаКонтрагенты = "Контрагенты";
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	Контрагенты.Ссылка
	|ИЗ
	|	Справочник."+НазваниеСправочникаКонтрагенты + " КАК Контрагенты
	|ГДЕ
	|	Контрагенты.ИНН = &ИНН";
	Запрос.УстановитьПараметр("ИНН", Сред(ИНН_КПП, 1, СтрНайти(ИНН_КПП, "/") - 1));
	
	Результат = Запрос.Выполнить().Выбрать();
	Если Результат.Следующий() Тогда
		Контрагент = Результат.Ссылка;
	Иначе
		Контрагент = ИнтеграцияЭДО.ПолучитьПустуюСсылку("Контрагенты");
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Служебные обработчики асинхронных диалогов

&НаКлиенте
Процедура ЗакончитьЗагрузку(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗаполнитьРеквизитыКонтрагента();
		Если Не ОткрытаФормаЭлемента Тогда
			ПоказатьЗначение(, Контрагент);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлОбработкаВыбора(Результат, Адрес, ИмяФайла, ДополнительныеПараметры) Экспорт
	
	Если Результат = Истина Тогда
		АдресВХранилище = Адрес;
		Файл = ИмяФайла;
		РазобратьФайлНаСервере();
	Иначе
		ОчиститьФорму();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
