#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Функция НовыеДанныеРегистрацииСчета() Экспорт
	
	ДанныеРегистрацииСчета = Новый Структура();
	РегистрМетаданные = СоздатьНаборЗаписей().Метаданные();
	
	Для Каждого Измерение Из РегистрМетаданные.Измерения Цикл
		ДанныеРегистрацииСчета.Вставить(Измерение.Имя);
	КонецЦикла;
	
	Возврат ДанныеРегистрацииСчета;
	
КонецФункции

Процедура ЗарегистрироватьДляНастройки(ДанныеРегистрацииСчета) Экспорт
	
	Для Каждого КлючИЗначение Из ДанныеРегистрацииСчета Цикл
		Если НЕ ЗначениеЗаполнено(КлючИЗначение.Значение)
			И (КлючИЗначение.Ключ = "ПланСчетов"
			ИЛИ КлючИЗначение.Ключ = "НастройкаФормированияПроводок"
			ИЛИ КлючИЗначение.Ключ = "ОбъектУчета") Тогда
			Возврат;
		КонецЕсли;
	КонецЦикла;
	
	Если НЕ ЗначениеЗаполнено(ДанныеРегистрацииСчета.ОбъектНастройки) Тогда
		ДанныеРегистрацииСчета.Вставить("ОбъектНастройки", Неопределено);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ДанныеРегистрацииСчета.Документ) Тогда
		ДанныеРегистрацииСчета.Вставить("Документ", Неопределено);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = СоздатьНаборЗаписей();
	
	Для Каждого КлючИЗначение Из ДанныеРегистрацииСчета Цикл
		НаборЗаписей.Отбор[КлючИЗначение.Ключ].Установить(КлючИЗначение.Значение);
	КонецЦикла;
	
	НаборЗаписей.Прочитать();
	
	Если НаборЗаписей.Количество() = 0 Тогда
		НоваяЗапись = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяЗапись, ДанныеРегистрацииСчета);
		НаборЗаписей.Записать();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли