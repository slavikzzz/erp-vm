#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - См. ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
//	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПриЗагрузкеПользовательскихНастроекНаСервере = Истина;
//	Настройки.События.ПослеЗаполненияПанелиБыстрыхНастроек = Истина;
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   ЭтаФорма - ФормаКлиентскогоПриложения - Форма отчета.
//   Отказ - Булево - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "ФормаКлиентскогоПриложения.ПриСозданииНаСервере" в синтакс-помощнике.
//
//Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
//	
//	// Дополнительные команды
//	КомпоновщикНастроекФормы = ЭтаФорма.Отчет.КомпоновщикНастроек;
//	Параметры = ЭтаФорма.Параметры;
//	
//	Если Параметры.Свойство("ЗаказНаПроизводство")
//		И ТипЗнч(Параметры.ЗаказНаПроизводство) = Тип("ДокументСсылка.ЗаказНаПроизводство2_2") Тогда
//	
//		Если НЕ ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.ЗаказНаПроизводство, "ДинамическаяСтруктура") Тогда
//			
//			ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Данный отчет применим только к заказам с включенной динамической структурой.'"));
//			Отказ = Истина;
//			Возврат;
//			
//		КонецЕсли;
//		
//		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроекФормы.Настройки, "ЗаказНаПроизводство", Параметры.ЗаказНаПроизводство, Истина, Истина);
//		
//	КонецЕсли;
//		
//КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма отчета.
//   НовыеПользовательскиеНастройкиКД - ПользовательскиеНастройкиКомпоновкиДанных -
//       Пользовательские настройки для загрузки в компоновщик настроек.
//
// См. синтакс-помощник "Расширение управляемой формы для отчета.ПриЗагрузкеПользовательскихНастроекНаСервере"
//    в синтакс-помощнике.
//
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Форма, НовыеПользовательскиеНастройкиКД) Экспорт
	
	Если Форма.Параметры.Свойство("ЗаказНаПроизводство")
		И ТипЗнч(Форма.Параметры.ЗаказНаПроизводство) = Тип("ДокументСсылка.ЗаказНаПроизводство2_2") Тогда
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ЗаказНаПроизводство", Форма.Параметры.ЗаказНаПроизводство);
		НовыеПользовательскиеНастройкиКД = КомпоновщикНастроек.ПолучитьНастройки();
	КонецЕсли;
	
КонецПроцедуры
#КонецОбласти

#КонецЕсли