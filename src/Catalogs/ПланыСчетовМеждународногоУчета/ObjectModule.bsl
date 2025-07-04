#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	
	Если Не МеждународныйУчетОбщегоНазначения.НастройкаПроводокПоОбъектамУчетаИлиРеглУчету() Тогда
		СпособУчетаНесобственныхПодконтрольныхЦенностей = Перечисления.СпособыУчетаНесобственныхПодконтрольныхЦенностей.НеОтражаютсяНаСчетах;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(СпособУчетаНесобственныхПодконтрольныхЦенностей) Тогда
		СпособУчетаНесобственныхПодконтрольныхЦенностей = Перечисления.СпособыУчетаНесобственныхПодконтрольныхЦенностей.НеОтражаютсяНаСчетах;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПредставлениеСчетов) Тогда
		ПредставлениеСчетов = Перечисления.ПредставлениеСчетовМеждународногоУчета.ВВидеКодаИНаименования;
	КонецЕсли;
	
КонецПроцедуры
	
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроводкиБезКорреспонденции = ВариантФормированияПроводок = Перечисления.ВариантыФормированияПроводок.БезКорреспонденции;
	ПроводкиСКорреспонденцией = ВариантФормированияПроводок = Перечисления.ВариантыФормированияПроводок.СКорреспонденцией;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
