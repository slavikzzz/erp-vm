#Область ОписаниеПеременных

&НаСервере
Перем мОбъектОтчета;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Раздел = Параметры.Раздел;
	Если Параметры.Раздел = "Графа3" Тогда 
		CountryCode = "RU";
		CounryName = "РОССИЯ";
		Элементы.CountryCode.ТолькоПросмотр = Истина;
		Элементы.CounryName.ТолькоПросмотр = Истина;
	КонецЕсли;
	ЗагрузитьДанные(Параметры.Данные);
	ДоступностьПолей(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура BusinessEntityTypeNameНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ПараметрВводаПоля = РегламентированнаяОтчетностьКлиентСервер.НайтиСвойстваПоказателя(ЭтотОбъект.ВладелецФормы, "ОрганизационноПравовыеФормы");
	Если ПараметрВводаПоля <> Неопределено И ПараметрВводаПоля.ТаблицаЗначений <> Неопределено Тогда
		СтандартнаяОбработка = Ложь;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Заголовок", ПараметрВводаПоля.ТекстПриВыборе);
		ПараметрыФормы.Вставить("ТаблицаЗначений", ПараметрВводаПоля.ТаблицаЗначений);
		ПараметрыФормы.Вставить("СтруктураДляПоиска", Новый Структура("Название", BusinessEntityTypeName));
		ОО = Новый ОписаниеОповещения("ОКОПФВыборЗавершение", ЭтотОбъект);
		ОткрытьФорму("Обработка.ОбщиеОбъектыРеглОтчетности.Форма.ФормаВыбораЗначенияИзТаблицы", ПараметрыФормы, ЭтотОбъект,,,, ОО, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СтранаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ПараметрВводаПоля = РегламентированнаяОтчетностьКлиентСервер.НайтиСвойстваПоказателя(ЭтотОбъект.ВладелецФормы, "КлСтранМира");
	Если ПараметрВводаПоля <> Неопределено И ПараметрВводаПоля.ТаблицаЗначений <> Неопределено Тогда
		СтандартнаяОбработка = Ложь;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Заголовок", ПараметрВводаПоля.ТекстПриВыборе);
		ПараметрыФормы.Вставить("ТаблицаЗначений", ПараметрВводаПоля.ТаблицаЗначений);
		ПараметрыФормы.Вставить("СтруктураДляПоиска", Новый Структура("Код", CountryCode));
		ОО = Новый ОписаниеОповещения("СтранаВыборЗавершение", ЭтотОбъект);
		ОткрытьФорму("Обработка.ОбщиеОбъектыРеглОтчетности.Форма.ФормаВыбораЗначенияИзТаблицы", ПараметрыФормы, ЭтотОбъект,,,, ОО, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОКАТОНачалоВыбора(Элемент, ДанныеВыбора, ВыборДобавлением, СтандартнаяОбработка)
	ПараметрВводаПоля = РегламентированнаяОтчетностьКлиентСервер.НайтиСвойстваПоказателя(ВладелецФормы, "ОКАТО");
	Если ПараметрВводаПоля <> Неопределено И ПараметрВводаПоля.ТаблицаЗначений <> Неопределено Тогда
		СтандартнаяОбработка = Ложь;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Заголовок", ПараметрВводаПоля.ТекстПриВыборе);
		ПараметрыФормы.Вставить("ТаблицаЗначений", ПараметрВводаПоля.ТаблицаЗначений);
		ПараметрыФормы.Вставить("СтруктураДляПоиска", Новый Структура("Код", CountryCode));
		ОО = Новый ОписаниеОповещения("ОКАТОВыборЗавершение", ЭтотОбъект);
		ОткрытьФорму("Обработка.ОбщиеОбъектыРеглОтчетности.Форма.ФормаВыбораЗначенияИзТаблицы", ПараметрыФормы, ЭтотОбъект,,,, ОО, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДокументНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ПараметрВводаПоля = РегламентированнаяОтчетностьКлиентСервер.НайтиСвойстваПоказателя(ЭтотОбъект.ВладелецФормы, "КодыДокументов");
	Если ПараметрВводаПоля <> Неопределено И ПараметрВводаПоля.ТаблицаЗначений <> Неопределено Тогда
		СтандартнаяОбработка = Ложь;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Заголовок", ПараметрВводаПоля.ТекстПриВыборе);
		ПараметрыФормы.Вставить("ТаблицаЗначений", ПараметрВводаПоля.ТаблицаЗначений);
		ПараметрыФормы.Вставить("СтруктураДляПоиска", Новый Структура("Код", IdentityCardCode));
		ОО = Новый ОписаниеОповещения("ДокументВыборЗавершение", ЭтотОбъект);
		ОткрытьФорму("Обработка.ОбщиеОбъектыРеглОтчетности.Форма.ФормаВыбораЗначенияИзТаблицы", ПараметрыФормы, ЭтотОбъект,,,, ОО, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеСтранаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ПараметрВводаПоля = РегламентированнаяОтчетностьКлиентСервер.НайтиСвойстваПоказателя(ЭтотОбъект.ВладелецФормы, "КлСтранМира");
	Если ПараметрВводаПоля <> Неопределено И ПараметрВводаПоля.ТаблицаЗначений <> Неопределено Тогда
		СтандартнаяОбработка = Ложь;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Заголовок", ПараметрВводаПоля.ТекстПриВыборе);
		ПараметрыФормы.Вставить("ТаблицаЗначений", ПараметрВводаПоля.ТаблицаЗначений);
		ПараметрыФормы.Вставить("СтруктураДляПоиска", Новый Структура("Код", BranchCountryCode));
		ОО = Новый ОписаниеОповещения("ПодразделениеСтранаВыборЗавершение", ЭтотОбъект);
		ОткрытьФорму("Обработка.ОбщиеОбъектыРеглОтчетности.Форма.ФормаВыбораЗначенияИзТаблицы", ПараметрыФормы, ЭтотОбъект,,,, ОО, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Ок(Команда)
	Закрыть(РезультатЗакрытия());
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	ОписаниеОповещенияОЗакрытии = Неопределено;
	Закрыть(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПоказатели(Команда)
	ОчиститьСообщения();
	ЕстьОшибки = Ложь;
	Если Не ЗначениеЗаполнено(OrganizationName) Тогда 
		Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаОсновное;
		ОбщегоНазначенияКлиент.СообщитьПользователю("Не указано наименование", , "OrganizationName");
		ЕстьОшибки = Истина;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(BusinessEntityTypeName) И "RU" = CountryCode Тогда 
		Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаОсновное;
		ОбщегоНазначенияКлиент.СообщитьПользователю("Не указана организационно-правовая форма", , "BusinessEntityTypeName");
		ЕстьОшибки = Истина;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ОКАТО) И "RU" = CountryCode Тогда 
		Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаОсновное;
		ОбщегоНазначенияКлиент.СообщитьПользователю("Не указан код ОКАТО", , "ОКАТО");
		ЕстьОшибки = Истина;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(CountryCode) Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаОсновное;
		ОбщегоНазначенияКлиент.СообщитьПользователю("Не указан код страны", , "CountryCode");
		ЕстьОшибки = Истина;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(CounryName) Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаОсновное;
		ОбщегоНазначенияКлиент.СообщитьПользователю("Не указано наименование страны", , "CounryName");
		ЕстьОшибки = Истина;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(City) Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаОсновное;
		ОбщегоНазначенияКлиент.СообщитьПользователю("Не указан город", , "City");
		ЕстьОшибки = Истина;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(StreetHouse) Тогда 
		Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаОсновное;
		ОбщегоНазначенияКлиент.СообщитьПользователю("Не указана улица/номер дома", , "StreetHouse");
		ЕстьОшибки = Истина;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(PostalCode) И "RU" = CountryCode Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаОсновное;
		ОбщегоНазначенияКлиент.СообщитьПользователю("Не указан почтовый индекс", , "PostalCode");
		ЕстьОшибки = Истина;
	КонецЕсли;
	Если "RU" = CountryCode Тогда 
		Если СтрДлина(RFINN) = 10 Тогда
			Если Не РегламентированныеДанныеКлиентСервер.ИННСоответствуетТребованиям(RFINN, Истина, "") Тогда 
				Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаИдентификаторы;
				ОбщегоНазначенияКлиент.СообщитьПользователю("Неправильно указан ИНН", , "RFINN");
				ЕстьОшибки = Истина;
			КонецЕсли;
			Если Не ЗначениеЗаполнено(RFKPP) Или Не РегламентированныеДанныеКлиентСервер.КППСоответствуетТребованиям(RFKPP, "") Тогда 
				Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаИдентификаторы;
				ОбщегоНазначенияКлиент.СообщитьПользователю("Не указан / неправильно указан КПП", , "RFKPP");
				ЕстьОшибки = Истина;
			КонецЕсли;
			Если Не ЗначениеЗаполнено(RFOGRN) Или Не РегламентированныеДанныеКлиентСервер.ОГРНСоответствуетТребованиям(RFOGRN, Истина, "") Тогда
				Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаИдентификаторы;
				ОбщегоНазначенияКлиент.СообщитьПользователю("Не указан / неправильно указан ОГРН", , "RFOGRN");
				ЕстьОшибки = Истина;
			КонецЕсли;
		ИначеЕсли СтрДлина(RFINN) = 12 Тогда 
			Если Не РегламентированныеДанныеКлиентСервер.ИННСоответствуетТребованиям(RFINN, Ложь, "") Тогда 
				Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаИдентификаторы;
				ОбщегоНазначенияКлиент.СообщитьПользователю("Неправильно указан ИНН", , "RFINN");
				ЕстьОшибки = Истина;
			КонецЕсли;
			Если ЗначениеЗаполнено(RFOGRN) И Не РегламентированныеДанныеКлиентСервер.ОГРНСоответствуетТребованиям(RFOGRN, Ложь, "") Тогда
				Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаИдентификаторы;
				ОбщегоНазначенияКлиент.СообщитьПользователю("Неправильно указан ОГРН", , "RFOGRN");
				ЕстьОшибки = Истина;
			ИначеЕсли Не ЗначениеЗаполнено(RFOGRN) И СтрНайти(НРег(BusinessEntityTypeName), "самозанят") = 0 Тогда 
				Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаИдентификаторы;
				ОбщегоНазначенияКлиент.СообщитьПользователю("Не указан ОГРН", , "RFOGRN");
				ЕстьОшибки = Истина;
			КонецЕсли;
		Иначе
			Если Не ЗначениеЗаполнено(RFINN) Тогда
				Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаИдентификаторы;
				ОбщегоНазначенияКлиент.СообщитьПользователю("Не указан ИНН", , "RFINN");
				ЕстьОшибки = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(BranchStreetHouse) Или ЗначениеЗаполнено(BranchCity)
		Или ЗначениеЗаполнено(BranchRegion) Или ЗначениеЗаполнено(BranchPostalCode)
		Или ЗначениеЗаполнено(BranchCounryName) Или ЗначениеЗаполнено(BranchCountryCode)
		Или ЗначениеЗаполнено(BranchOrganizationName) Тогда 
		
		Если Не ЗначениеЗаполнено(BranchCountryCode) Тогда
			Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаОбособленноеПодразделение;
			ОбщегоНазначенияКлиент.СообщитьПользователю("Не указан код страны", , "BranchCountryCode");
			ЕстьОшибки = Истина;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(BranchCounryName) Тогда 
			Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаОбособленноеПодразделение;
			ОбщегоНазначенияКлиент.СообщитьПользователю("Не указано наименование страны", , "BranchCounryName");
			ЕстьОшибки = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(IdentityCardOrganizationName) Или ЗначениеЗаполнено(IdentityCardDate)
		Или ЗначениеЗаполнено(IdentityCardNumber) Или ЗначениеЗаполнено(IdentityCardSeries)
		Или ЗначениеЗаполнено(IdentityCardName) Или ЗначениеЗаполнено(IdentityCardCode) Тогда 
		
		Если Не ЗначениеЗаполнено(IdentityCardCode) Тогда 
			Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаДокумент;
			ОбщегоНазначенияКлиент.СообщитьПользователю("Не указан код вида документа", , "IdentityCardCode");
			ЕстьОшибки = Истина;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(IdentityCardName) Тогда
			Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаДокумент;
			ОбщегоНазначенияКлиент.СообщитьПользователю("Не указан документ", , "IdentityCardName");
			ЕстьОшибки = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Для Каждого Стр Из CommunicationDetails Цикл 
		Если Не ЗначениеЗаполнено(Стр.Phone) Или Не ЗначениеЗаполнено(Стр.E_mail) Тогда 
			Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаКонтакты;
			Элементы.CommunicationDetails.ТекущаяСтрока = Стр.ПолучитьИдентификатор();
			ОбщегоНазначенияКлиент.СообщитьПользователю("Необходимо указать и телефон и адрес электронной почты", , "CommunicationDetails");
			ЕстьОшибки = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ЕстьОшибки Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю("Ошибок не обнаружено");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьСведения(Команда)
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаОбособленноеПодразделение Тогда
		Для Каждого РеквизитПодразделения Из СтрРазделить("BranchOrganizationName,BranchPostalCode,BranchRegion,BranchCity,BranchStreetHouse,"
			+"RFOGRNBranch,RFINNBranch,RFKPPBranch,RBUNPBranch,RBIdentificationNumberBranch,RKBINBranch,RKIINBranch,RASocialServiceNumberBranch,"
			+"RAUNNBranch,RASocialServiceCertificateBranch,KGINNBranch,KGOKPOBranch,BranchCountryCode,BranchCounryName", ",") Цикл 
			
			ЭтотОбъект[РеквизитПодразделения] = Неопределено;
		КонецЦикла;
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаДокумент Тогда
		Для Каждого РеквизитПодразделения Из СтрРазделить("IdentityCardCode,IdentityCardName,IdentityCardSeries,IdentityCardNumber,"
			+"IdentityCardDate,IdentityCardOrganizationName", ",") Цикл 
			
			ЭтотОбъект[РеквизитПодразделения] = Неопределено;
		КонецЦикла;
	КонецЕсли;
	ДоступностьПолей(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ОбъектОтчета(ЭтаФормаИмя) Экспорт
	Если мОбъектОтчета = Неопределено Тогда 
		мОбъектОтчета = РегламентированнаяОтчетностьВызовСервера.ОбъектОтчета(ЭтаФормаИмя);
	КонецЕсли;
	
	Возврат мОбъектОтчета;
КонецФункции

&НаКлиенте
Процедура ОКОПФВыборЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(РезультатВыбора["Код"]) Тогда
		BusinessEntityTypeName = "";
	Иначе 
		BusinessEntityTypeName = РезультатВыбора["Название"];
	КонецЕсли;
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОчиститьПоказатели(Форма, Показатели)
	Для Каждого Стр Из СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Показатели, ",", Истина) Цикл 
		Форма[Стр] = Неопределено;
	КонецЦикла;
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ДоступностьПолей(Форма)
	Элементы = Форма.Элементы;
	Элементы.ДекорацияОсновноеРеквизиты2_2.Видимость = (Форма.CountryCode = "RU");
	Элементы.ГруппаОсновноеРеквизиты3.Видимость = (Форма.CountryCode = "RU");
	
	Элементы.ДекорацияОсновноеРеквизиты5_2.Видимость = (Форма.CountryCode = "RU");
	
	Элементы.ГруппаRU.Видимость = (Форма.CountryCode = "RU");
	Элементы.ГруппаBY.Видимость = (Форма.CountryCode = "BY");
	Элементы.ГруппаKZ.Видимость = (Форма.CountryCode = "KZ");
	Элементы.ГруппаAM.Видимость = (Форма.CountryCode = "AM");
	Элементы.ГруппаKG.Видимость = (Форма.CountryCode = "KG");
	Элементы.ГруппаОсновноеОКАТО.Видимость = (Форма.CountryCode = "RU");
	
	Элементы.ГруппаRUBranch.Видимость = (Форма.BranchCountryCode = "RU");
	Элементы.ГруппаBYBranch.Видимость = (Форма.BranchCountryCode = "BY");
	Элементы.ГруппаKZBranch.Видимость = (Форма.BranchCountryCode = "KZ");
	Элементы.ГруппаAMBranch.Видимость = (Форма.BranchCountryCode = "AM");
	Элементы.ГруппаKGBranch.Видимость = (Форма.BranchCountryCode = "KG");
	
	Если Форма.CountryCode = "RU" Тогда
		ПоказателиДляОчистки = "RBUNP,RBIdentificationNumber,RKBIN,RKIIN,RAUNN,RASocialServiceNumber,RASocialServiceCertificate,KGINN,KGOKPO";
		ОчиститьПоказатели(Форма, ПоказателиДляОчистки);
	ИначеЕсли Форма.CountryCode = "BY" Тогда
		ПоказателиДляОчистки = "RFOGRN,RFINN,RFKPP,RKBIN,RKIIN,RAUNN,RASocialServiceNumber,RASocialServiceCertificate,KGINN,KGOKPO,ОКАТО";
		ОчиститьПоказатели(Форма, ПоказателиДляОчистки);
	ИначеЕсли Форма.CountryCode = "KZ" Тогда 
		ПоказателиДляОчистки = "RFOGRN,RFINN,RFKPP,RBUNP,RBIdentificationNumber,RAUNN,RASocialServiceNumber,RASocialServiceCertificate,KGINN,KGOKPO,ОКАТО";
		ОчиститьПоказатели(Форма, ПоказателиДляОчистки);
	ИначеЕсли Форма.CountryCode = "AM" Тогда 
		ПоказателиДляОчистки = "RFOGRN,RFINN,RFKPP,RBUNP,RBIdentificationNumber,RKBIN,RKIIN,KGINN,KGOKPO,ОКАТО";
		ОчиститьПоказатели(Форма, ПоказателиДляОчистки);
	ИначеЕсли Форма.CountryCode = "KG" Тогда 
		ПоказателиДляОчистки = "RFOGRN,RFINN,RFKPP,RBUNP,RBIdentificationNumber,RKBIN,RKIIN,RAUNN,RASocialServiceNumber,RASocialServiceCertificate,ОКАТО";
		ОчиститьПоказатели(Форма, ПоказателиДляОчистки);
	Иначе
		ПоказателиДляОчистки = "RFOGRN,RFINN,RFKPP,RBUNP,RBIdentificationNumber,RKBIN,RKIIN,RAUNN,RASocialServiceNumber,"
			+ "RASocialServiceCertificate,KGINN,KGOKPO,ОКАТО";
		ОчиститьПоказатели(Форма, ПоказателиДляОчистки);
	КонецЕсли;
	
	Если Форма.BranchCountryCode = "RU" Тогда
		ПоказателиДляОчистки = "RBUNPBranch,RBIdentificationNumberBranch,RKBINBranch,RKIINBranch,RAUNNBranch,RASocialServiceNumberBranch,"
			+ "RASocialServiceCertificateBranch,KGINNBranch,KGOKPOBranch";
		ОчиститьПоказатели(Форма, ПоказателиДляОчистки);
	ИначеЕсли Форма.BranchCountryCode = "BY" Тогда
		ПоказателиДляОчистки = "RFOGRNBranch,RFINNBranch,RFKPPBranch,RKBINBranch,RKIINBranch,RAUNNBranch,RASocialServiceNumberBranch,"
			+ "RASocialServiceCertificateBranch,KGINNBranch,KGOKPOBranch";
		ОчиститьПоказатели(Форма, ПоказателиДляОчистки);
	ИначеЕсли Форма.BranchCountryCode = "KZ" Тогда 
		ПоказателиДляОчистки = "RFOGRNBranch,RFINNBranch,RFKPPBranch,RBUNPBranch,RBIdentificationNumberBranch,RAUNNBranch,"
			+ "RASocialServiceNumberBranch,RASocialServiceCertificateBranch,KGINNBranch,KGOKPOBranch";
		ОчиститьПоказатели(Форма, ПоказателиДляОчистки);
	ИначеЕсли Форма.BranchCountryCode = "AM" Тогда 
		ПоказателиДляОчистки = "RFOGRNBranch,RFINNBranch,RFKPPBranch,RBUNPBranch,RBIdentificationNumberBranch,RKBINBranch,RKIINBranch,"
			+ "KGINNBranch,KGOKPOBranch";
		ОчиститьПоказатели(Форма, ПоказателиДляОчистки);
	ИначеЕсли Форма.BranchCountryCode = "KG" Тогда 
		ПоказателиДляОчистки = "RFOGRNBranch,RFINNBranch,RFKPPBranch,RBUNPBranch,RBIdentificationNumberBranch,RKBINBranch,RKIINBranch,"
			+ "RAUNNBranch,RASocialServiceNumberBranch,RASocialServiceCertificateBranch";
		ОчиститьПоказатели(Форма, ПоказателиДляОчистки);
	Иначе
		ПоказателиДляОчистки = "RFOGRNBranch,RFINNBranch,RFKPPBranch,RBUNPBranch,RBIdentificationNumberBranch,RKBINBranch,RKIINBranch,"
			+ "RAUNNBranch,RASocialServiceNumberBranch,RASocialServiceCertificateBranch,KGINNBranch,KGOKPOBranch";
		ОчиститьПоказатели(Форма, ПоказателиДляОчистки);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДанные(Данные)
	Если Не ЗначениеЗаполнено(Данные) Тогда 
		Возврат;
	КонецЕсли;
	
	ФормаУчетаПеремещенияТоваровТС.ЗагрузитьДанныеВФорму(ЭтотОбъект, Данные)
КонецПроцедуры

&НаКлиенте
Процедура СтранаВыборЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(РезультатВыбора["Код"]) Тогда
		CountryCode = "";
		CounryName = "";
	Иначе 
		CountryCode = РезультатВыбора["Код"];
		CounryName = РезультатВыбора["Название"];
	КонецЕсли;
	ДоступностьПолей(ЭтотОбъект);
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОКАТОВыборЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОКАТО = РезультатВыбора["Код"];
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ДокументВыборЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Истина;
	Если Не ЗначениеЗаполнено(РезультатВыбора["Код"]) Тогда
		IdentityCardCode = "";
		IdentityCardName = "";
	Иначе 
		IdentityCardCode = РезультатВыбора["Код"];
		НайденныеСтроки = РегламентированнаяОтчетностьКлиентСервер.НайтиСвойстваПоказателя(
			ЭтотОбъект.ВладелецФормы, "КодыДокументов").ТаблицаЗначений.НайтиСтроки(Новый Структура("Код", IdentityCardCode));
		Если НайденныеСтроки.Количество() = 0 Тогда 
			IdentityCardName = "";
		Иначе
			IdentityCardName = НайденныеСтроки[0].Фильтр1;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеСтранаВыборЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(РезультатВыбора["Код"]) Тогда
		BranchCountryCode = "";
		BranchCounryName = "";
	Иначе 
		BranchCountryCode = РезультатВыбора["Код"];
		BranchCounryName = РезультатВыбора["Название"];
	КонецЕсли;
	ДоступностьПолей(ЭтотОбъект);
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПроверитьЗаполнениеПоказателейНаНаличиеОшибок(Форма)
	Если Не ЗначениеЗаполнено(Форма.StreetHouse) Или Не ЗначениеЗаполнено(Форма.City) Или Не ЗначениеЗаполнено(Форма.OrganizationName)
		Или Не ЗначениеЗаполнено(Форма.CountryCode) Или Не ЗначениеЗаполнено(Форма.CounryName) Тогда 
		Возврат Ложь;
	КонецЕсли;
	Если "RU" = Форма.CountryCode Тогда 
		Если СтрДлина(Форма.RFINN) = 10 Тогда
			Если Не РегламентированныеДанныеКлиентСервер.ИННСоответствуетТребованиям(Форма.RFINN, Истина, "") Тогда 
				Возврат Ложь;
			КонецЕсли;
			Если Не ЗначениеЗаполнено(Форма.RFKPP) Или Не РегламентированныеДанныеКлиентСервер.КППСоответствуетТребованиям(Форма.RFKPP, "") Тогда 
				Возврат Ложь;
			КонецЕсли;
			Если Не ЗначениеЗаполнено(Форма.RFOGRN) Или Не РегламентированныеДанныеКлиентСервер.ОГРНСоответствуетТребованиям(Форма.RFOGRN, Истина, "") Тогда
				Возврат Ложь;
			КонецЕсли;
		ИначеЕсли СтрДлина(Форма.RFINN) = 12 Тогда 
			Если Не РегламентированныеДанныеКлиентСервер.ИННСоответствуетТребованиям(Форма.RFINN, Ложь, "") Тогда 
				Возврат Ложь;
			КонецЕсли;
			Если Не ЗначениеЗаполнено(Форма.RFOGRN) Тогда 
				Если СтрНайти(НРег(Форма.BusinessEntityTypeName), "самозаняты") = 0 Тогда 
					Возврат Ложь;
				КонецЕсли;
			ИначеЕсли Не РегламентированныеДанныеКлиентСервер.ОГРНСоответствуетТребованиям(Форма.RFOGRN, Ложь, "") Тогда
				Возврат Ложь;
			КонецЕсли;
		Иначе
			Если Не ЗначениеЗаполнено(Форма.RFINN) Тогда 
				Возврат Ложь;
			КонецЕсли;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Форма.BusinessEntityTypeName) 
			Или Не ЗначениеЗаполнено(Форма.PostalCode) 
			Или Не ЗначениеЗаполнено(Форма.ОКАТО) Тогда 
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Форма.BranchStreetHouse) Или ЗначениеЗаполнено(Форма.BranchCity)
		Или ЗначениеЗаполнено(Форма.BranchRegion) Или ЗначениеЗаполнено(Форма.BranchPostalCode)
		Или ЗначениеЗаполнено(Форма.BranchCounryName) Или ЗначениеЗаполнено(Форма.BranchCountryCode)
		Или ЗначениеЗаполнено(Форма.BranchOrganizationName) Тогда 
		
		Если Не ЗначениеЗаполнено(Форма.BranchCountryCode) Или Не ЗначениеЗаполнено(Форма.BranchCounryName) Тогда 
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Форма.IdentityCardOrganizationName) Или ЗначениеЗаполнено(Форма.IdentityCardDate)
		Или ЗначениеЗаполнено(Форма.IdentityCardNumber) Или ЗначениеЗаполнено(Форма.IdentityCardSeries)
		Или ЗначениеЗаполнено(Форма.IdentityCardName) Или ЗначениеЗаполнено(Форма.IdentityCardCode) Тогда 
		
		Если Не ЗначениеЗаполнено(Форма.IdentityCardCode) Или Не ЗначениеЗаполнено(Форма.IdentityCardName) Тогда 
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Для Каждого Стр Из Форма.CommunicationDetails Цикл 
		Если Не ЗначениеЗаполнено(Стр.Phone) Или Не ЗначениеЗаполнено(Стр.E_mail) Тогда 
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
КонецФункции

&НаСервере
Функция РезультатЗакрытия()
	РезультатЗакрытия = Новый Структура;
	РезультатЗакрытия.Вставить("Данные", ФормаУчетаПеремещенияТоваровТС.СформироватьJSONГрафы123(ЭтотОбъект, Раздел));
	РезультатЗакрытия.Вставить("Описание", ФормаУчетаПеремещенияТоваровТС.СформироватьОписаниеРезультаГрафы123(ЭтотОбъект));
	РезультатЗакрытия.Вставить("КорректностьЗаполнения", Не ПроверитьЗаполнениеПоказателейНаНаличиеОшибок(ЭтотОбъект));
	Возврат РезультатЗакрытия;
КонецФункции

&НаКлиенте
Функция КорректностьПоказателей() Экспорт 
	Возврат ПроверитьЗаполнениеПоказателейНаНаличиеОшибок(ЭтотОбъект);
КонецФункции

#КонецОбласти
