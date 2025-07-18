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
	
	Если НЕ ПравоДоступа("СохранениеДанныхПользователя", Метаданные) Тогда
		Элементы.БольшеНеПредупреждать.Видимость = Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ТекстСообщения) Тогда
		Элементы.ДекорацияТекстСообщения.Заголовок = СтроковыеФункции.ФорматированнаяСтрока(Параметры.ТекстСообщения);
	КонецЕсли;
	
	Если Параметры.ЭтоПроверкаПередОтправкой Тогда
		Элементы.ОК.Заголовок = НСтр("ru = 'Продолжить отправку';
									|en = 'Continue sending'");
		Элементы.Отмена.Заголовок = НСтр("ru = 'Отменить отправку';
										|en = 'Cancel sending'");
	Иначе
		Элементы.Отмена.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура БольшеНеПредупреждатьПриИзменении(Элемент)
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(
		"ЗаявлениеНаВыпускНовогоКвалифицированногоСертификата",
		"ПоказыватьИнформациюОДоступностиВыпускаСертификатаДляРуководителей",
		Не БольшеНеПредупреждать);
	
КонецПроцедуры

#КонецОбласти