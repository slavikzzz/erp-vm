///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НастройкиПользователя = Параметры.НастройкиПользователя;
	
	ЗаполнитьНачальныеНастройки();
	ВебАутентификация = СформироватьАдресФормы();
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если СервисКриптографииDSSСлужебныйКлиент.ПередЗакрытиемФормы(
			ЭтотОбъект,
			Отказ,
			ПрограммноеЗакрытие,
			ЗавершениеРаботы) Тогда
		ЗакрытьФорму();
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВебАутентификацияДокументСформирован(Элемент)
	
	Элементы.Слои.ТекущаяСтраница = Элементы.Пустая;
	ПодключитьОбработчикОжидания("Подключаемый_СтраницаОбновлена", 0.1, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_СтраницаОбновлена()
	
	ИщемСтроку = НастройкиПользователя.Подключение.Заглушка;
	КодАвторизации = ПолучитьКодАвторизации(ИщемСтроку);
	
	Если ЗначениеЗаполнено(КодАвторизации) Тогда
		ОбработчикОтвета = Новый ОписаниеОповещения("ПолучитьРезультатСервиса", ЭтотОбъект);
		Если КодАвторизации <> Неопределено Тогда
			ОписаниеОперации = ПолучитьТокенПоКодуАвторизации(КодАвторизации);
			СервисКриптографииDSSСлужебныйКлиент.ОжидатьЗавершенияВыполненияВФоне(ОбработчикОтвета, ОписаниеОперации);
		Иначе
			ЗакрытьФорму(Неопределено);
		КонецЕсли;	
		Элементы.Слои.ТекущаяСтраница = Элементы.Пустая;
	Иначе
		Элементы.Слои.ТекущаяСтраница = Элементы.ВводПароля;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Функция ПолучитьКодАвторизации(ИщемСтроку)
	
	Результат = "";
	
	Попытка
		ПоляПоиска = Новый Структура("activeElement, innerText, url", "", "", "");
		ЗаполнитьЗначенияСвойств(ПоляПоиска, Элементы.ВебАутентификация.Документ);
		
		Если ПоляПоиска.activeElement = Неопределено Тогда
			ИсходнаяСтрока = ПоляПоиска.url;
		Иначе
			ЗаполнитьЗначенияСвойств(ПоляПоиска, ПоляПоиска.activeElement);
			ИсходнаяСтрока = ПоляПоиска.innerText;
		КонецЕсли;
		
	Исключение
		ИсходнаяСтрока = "";
		
	КонецПопытки;
	
	Позиция	= СтрНайти(ИсходнаяСтрока, ИщемСтроку);
	Если Позиция > 0 Тогда
		КодАвторизации = Сред(ИсходнаяСтрока, СтрДлина(ИщемСтроку) + Позиция);
		ПараметрыОтвета = СервисКриптографииDSSСлужебныйВызовСервера.ПолучитьПараметрыИзОтвета(КодАвторизации);
		Результат = ПараметрыОтвета["code"];
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

&НаКлиенте
Процедура ПолучитьРезультатСервиса(РезультатЗапроса, ДополнительныеПараметры) Экспорт
	
	РезультатЗапроса = СервисКриптографииDSSСлужебныйКлиент.ПолучитьРезультатВыполненияВФоне(РезультатЗапроса);

	Если РезультатЗапроса.Выполнено Тогда
		ЗакрытьФорму(РезультатЗапроса);
	Иначе
		ОповещениеСледующее = Новый ОписаниеОповещения("ОтобразитьОшибкуПользователюПослеПоказа", ЭтотОбъект, РезультатЗапроса);
		СервисКриптографииDSSКлиент.ВывестиОшибку(ОповещениеСледующее, РезультатЗапроса.СтатусОшибки);
	КонецЕсли;	
	
КонецПроцедуры	

&НаКлиенте
Процедура ОтобразитьОшибкуПользователюПослеПоказа(РезультатДиалога, РезультатВыполнения) Экспорт
	
	ЗакрытьФорму(РезультатВыполнения);
	
КонецПроцедуры	

&НаКлиенте
Процедура ЗакрытьФорму(РезультатАвторизации = Неопределено)
	
	РезультатРаботы = СервисКриптографииDSSКлиент.ОтветСервисаПоУмолчанию(Ложь);
	Если РезультатАвторизации <> Неопределено Тогда
		РезультатРаботы = РезультатАвторизации;
	Иначе	
		СервисКриптографииDSSСлужебныйКлиент.СформироватьОтказАутентификации(РезультатРаботы);
	КонецЕсли;
	ПрограммноеЗакрытие = Истина;
	
	Закрыть(РезультатРаботы);
	
КонецПроцедуры	

&НаСервере
Функция СформироватьАдресФормы()
	
	Результат = "";
	Если НастройкиПользователя <> Неопределено Тогда
		Результат = СервисКриптографииDSS.ПолучитьАдресВебАутентификации(НастройкиПользователя);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПолучитьТокенПоКодуАвторизации(КодАвторизации)
	
	ПараметрыЗадания = Новый Структура();
	ПараметрыЗадания.Вставить("НастройкиПользователя", НастройкиПользователя);
	ПараметрыЗадания.Вставить("КодАвторизации", КодАвторизации);
	
	ОписаниеОперации = СервисКриптографииDSSСлужебный.ВыполнитьВФоне(
		"СервисКриптографииDSSСлужебный.ПолучитьТокенПоКодуАвторизации", ПараметрыЗадания);
	
	Возврат ОписаниеОперации;
	
КонецФункции	

&НаСервере
Процедура ЗаполнитьНачальныеНастройки()
	
	ОбщаяИнформация = Новый СистемнаяИнформация;
	ТипКлиента		= "ТонкийКлиент";
	Браузер			= "";
	
	Если ОбщегоНазначения.ЭтоВебКлиент() Тогда
		ТипКлиента	= "ВебКлиент";
	ИначеЕсли ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		ТипКлиента	= "МобильныйКлиент";
	КонецЕсли;	
	
	Браузер = ОбщаяИнформация.ИнформацияПрограммыПросмотра;
	
КонецПроцедуры	

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(КонтекстФормы)
	
	Элементы = КонтекстФормы.Элементы;
	
	Элементы.Слои.ОтображениеСтраниц 	= ОтображениеСтраницФормы.Нет;
	Элементы.Слои.ТекущаяСтраница 		= Элементы.Пустая;
	
	Если ПустаяСтрока(КонтекстФормы.ВебАутентификация) Тогда
		Элементы.ДлительнаяОперация.Вид = ВидДекорацииФормы.Надпись;
		Элементы.ДлительнаяОперация.Заголовок = 
			НСтр("ru = 'Для пользователя не предусмотрена интерактивная авторизация';
				|en = 'Interactive authorization is not available to the user'");
		Элементы.ДлительнаяОперация.Подсказка = "";
	Иначе
		Элементы.ДлительнаяОперация.Подсказка = НСтр("ru = 'Ожидание ответа';
													|en = 'Waiting for response'");
	КонецЕсли;
	
КонецПроцедуры	

#КонецОбласти

