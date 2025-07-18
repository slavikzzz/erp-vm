///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.СогласиеНаОбработкуПерсональныхДанных") Тогда
		ИменаРеквизитов = 
			"Организация, 
			|ЮридическийАдресОрганизации,
			|ОтветственныйЗаОбработкуПерсональныхДанных,
			|Субъект";
		ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения, ИменаРеквизитов);
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗначенияРеквизитов);
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЭтоНовый() И ЗащитаПерсональныхДанных.ЭтоОбъектСУничтоженнымиПерсональнымиДанными(Субъект) Тогда
		ТекстСообщения = НСтр("ru = 'Персональные данные субъекта уже были уничтожены.';
								|en = 'The subject''s personal data has already been destroyed.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , "Объект.Субъект", , Отказ);
		Возврат;
	КонецЕсли;
	
	// Проверяем, что на указанную дату не было других записей о согласии.
	Согласие = ЗащитаПерсональныхДанных.ДействующееСогласиеНаОбработкуПерсональныхДанных(Субъект, Организация,
		ДатаОтзыва, Ссылка);
	Если Согласие <> Неопределено Тогда
		Если ДатаОтзыва = Согласие.ДатаПолучения Тогда
			ТекстСообщения = НСтр(
				"ru = 'На указанную дату зарегистрировано согласие. Оформление отзыва согласия в тот же день не поддерживается.';
				|en = 'Consent is registered on the specified date. Registration of consent withdrawal on the same day is not supported.'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Согласие.ДокументОснование, "Объект.ДатаОтзыва", , Отказ);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ОписаниеРегистрации = ЗащитаПерсональныхДанных.ОписаниеРегистрацииСогласияНаОбработкуПерсональныхДанных();
	ОписаниеРегистрации.Организация = Организация; 
	ОписаниеРегистрации.Субъект = Субъект;
	ОписаниеРегистрации.ДатаРегистрации = ДатаОтзыва;
	ОписаниеРегистрации.Действует = Ложь;
	
	ЗащитаПерсональныхДанных.ЗарегистрироватьСведенияОСогласииНаОбработкуПерсональныхДанных(Движения, ОписаниеРегистрации);
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли