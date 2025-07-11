///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2025, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Параметры.Свойство("Корреспондент") 
		И Не Параметры.Свойство("ИдентификаторТранспорта") 
		И Не Параметры.Свойство("ИмяПланаОбмена")
		И Не Параметры.Свойство("НастройкиТранспорта") Тогда
		
		ВызватьИсключение НСтр("ru = 'Эта форма не предназначена для непосредственного открытия.';
								|en = 'This form is not intended for direct opening.'",
			ОбщегоНазначения.КодОсновногоЯзыка());
		
	КонецЕсли;
	
	Корреспондент = Параметры.Корреспондент;
	ИдентификаторТранспорта = Параметры.ИдентификаторТранспорта;
	ИмяПланаОбмена = Параметры.ИмяПланаОбмена;
	НастройкиТранспорта = Параметры.НастройкиТранспорта;
	
	ДанныеАутентификации = Новый Структура;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
		
	ДанныеАутентификации.Вставить("Пароль", Пароль);
	
	Элементы.ВыполнениеПроверкиПодключения.ТекущаяСтраница = Элементы.ОжиданиеПроверкиПодключения;
	
	ФоновоеЗадание = ПроверкаАутентификацииНачало(
		?(ЗначениеЗаполнено(Корреспондент), Корреспондент, ИмяПланаОбмена),
		ИдентификаторТранспорта,
		ДанныеАутентификации);
	
	НастройкиОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	НастройкиОжидания.ВыводитьОкноОжидания = Ложь;
	
	Обработчик = Новый ОписаниеОповещения("ПроверкаАутентификацииЗавершение", ЭтотОбъект);
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ФоновоеЗадание, Обработчик, НастройкиОжидания);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПроверкаАутентификацииНачало(Знач Корреспондент, Знач ИдентификаторТранспорта, Знач ДанныеАутентификации) Экспорт
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Проверка подключения к корреспонденту';
															|en = 'Check connection to peer'", ОбщегоНазначения.КодОсновногоЯзыка());
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
		
	Возврат ДлительныеОперации.ВыполнитьФункцию(
		ПараметрыВыполнения,
		"ТранспортСообщенийОбмена.ПроверитьАутентификацию",
		Корреспондент, ИдентификаторТранспорта, НастройкиТранспорта, ДанныеАутентификации);
	
КонецФункции
	
&НаКлиенте
Процедура ПроверкаАутентификацииЗавершение(ФоновоеЗадание, ДополнительныеПараметры) Экспорт 
	
	Если ФоновоеЗадание = Неопределено Тогда
		
		Возврат;
	
	ИначеЕсли ФоновоеЗадание.Статус = "Ошибка" Тогда 
		
		Элементы.ВыполнениеПроверкиПодключения.ТекущаяСтраница = Элементы.ЗапросПароляПользователя;
		СообщениеОбОшибке = ФоновоеЗадание.КраткоеПредставлениеОшибки
			+ Символы.ПС + НСтр("ru = 'Техническую информацию об ошибке см. в журнале регистрации.';
								|en = 'See the event log for details.'");
			
		ОбщегоНазначенияКлиент.СообщитьПользователю(СообщениеОбОшибке);

	Иначе
		
		Закрыть(ДанныеАутентификации);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти