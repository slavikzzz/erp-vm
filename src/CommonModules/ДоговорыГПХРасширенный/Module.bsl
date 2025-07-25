#Область СлужебныйПрограммныйИнтерфейс

#Область ОбновлениеИнформационнойБазы

// См. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления.
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "Справочники.ВидыДоговоровАвторскогоЗаказа.СоздатьПредопределенныеВидыДоговоров";
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.ОбщиеДанные = Ложь;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия          = "3.1.29.18";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор   = Новый УникальныйИдентификатор("e4be4199-cb89-11ee-811a-4cedfb43b11a");
	Обработчик.Процедура       = "Документы.ДоговорРаботыУслуги.ОбновитьДанныеОВремениДляСреднегоФСС";
	Обработчик.Комментарий     = НСтр("ru = 'Обновление данных о времени в договорах ГПХ.';
										|en = 'Update data about time in civil law contracts.'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия          = "3.1.29.18";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор   = Новый УникальныйИдентификатор("e4be419b-cb89-11ee-811a-4cedfb43b11a");
	Обработчик.Процедура       = "Документы.ДоговорАвторскогоЗаказа.ОбновитьДанныеОВремениДляСреднегоФСС";
	Обработчик.Комментарий     = НСтр("ru = 'Обновление данных о времени в авторских договорах.';
										|en = 'Update data about time in copyright agreements.'");
	
КонецПроцедуры

// См. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковПереходаСДругойПрограммы.
Процедура ПриДобавленииОбработчиковПереходаСДругойПрограммы(Обработчики) Экспорт
	
	ИмяПроцедуры = "Справочники.ВидыДоговоровАвторскогоЗаказа.СоздатьПредопределенныеВидыДоговоров";
	ОбщиеДанные  = Ложь;
	ОбновлениеБЗК.ДобавитьОбработчикПерехода(Обработчики, ИмяПроцедуры, ОбщиеДанные);
	
КонецПроцедуры

#КонецОбласти

#Область Печать

// Определяет объекты, в которых есть процедура ДобавитьКомандыПечати().
// Подробнее см. УправлениеПечатьюПереопределяемый.
//
// Параметры:
//  СписокОбъектов - Массив - список менеджеров объектов.
//
Процедура ПриОпределенииОбъектовСКомандамиПечати(СписокОбъектов) Экспорт
	
	СписокОбъектов.Добавить(Документы.АктПриемкиВыполненныхРаботОказанныхУслуг);
	СписокОбъектов.Добавить(Документы.ДоговорАвторскогоЗаказа);
	СписокОбъектов.Добавить(Документы.ДоговорРаботыУслуги);
	СписокОбъектов.Добавить(Документы.НачислениеПоДоговорам);
	
КонецПроцедуры

#КонецОбласти

#Область Свойства

// См. УправлениеСвойствамиПереопределяемый.ПриПолученииПредопределенныхНаборовСвойств.
Процедура ПриПолученииПредопределенныхНаборовСвойств(Наборы) Экспорт
	
	УправлениеСвойствамиБЗК.ЗарегистрироватьНаборСвойств(Наборы, "d42dbfd5-9802-11e9-80cd-4cedfb43b11a", Метаданные.Документы.АктПриемкиВыполненныхРаботОказанныхУслуг);
	УправлениеСвойствамиБЗК.ЗарегистрироватьНаборСвойств(Наборы, "d42dbfc6-9802-11e9-80cd-4cedfb43b11a", Метаданные.Документы.ДоговорАвторскогоЗаказа);
	УправлениеСвойствамиБЗК.ЗарегистрироватьНаборСвойств(Наборы, "d42dbfe6-9802-11e9-80cd-4cedfb43b11a", Метаданные.Документы.ДоговорРаботыУслуги);
	УправлениеСвойствамиБЗК.ЗарегистрироватьНаборСвойств(Наборы, "d42dbf19-9802-11e9-80cd-4cedfb43b11a", Метаданные.Документы.НачислениеПоДоговорам);
	УправлениеСвойствамиБЗК.ЗарегистрироватьНаборСвойств(Наборы, "d42dbf42-9802-11e9-80cd-4cedfb43b11a", Метаданные.Справочники.ВидыДоговоровАвторскогоЗаказа);
	
КонецПроцедуры

#КонецОбласти

#Область УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииСписковСОграничениемДоступа(Списки) Экспорт
	
	Списки.Вставить(Метаданные.Справочники.АктПриемкиВыполненныхРаботОказанныхУслугПрисоединенныеФайлы, Истина);
	Списки.Вставить(Метаданные.Справочники.ДоговорАвторскогоЗаказаПрисоединенныеФайлы, Истина);
	Списки.Вставить(Метаданные.Справочники.ДоговорРаботыУслугиПрисоединенныеФайлы, Истина);
	Списки.Вставить(Метаданные.Документы.АктПриемкиВыполненныхРаботОказанныхУслуг, Истина);
	Списки.Вставить(Метаданные.Документы.ДоговорАвторскогоЗаказа, Истина);
	Списки.Вставить(Метаданные.Документы.ДоговорРаботыУслуги, Истина);
	Списки.Вставить(Метаданные.Документы.НачислениеПоДоговорам, Истина);
	Списки.Вставить(Метаданные.Справочники.НачислениеПоДоговорамПрисоединенныеФайлы, Истина);
	Списки.Вставить(Метаданные.ЖурналыДокументов.ДоговорыГражданскоПравовогоХарактера, Истина);
	
КонецПроцедуры

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииВидовОграниченийПравОбъектовМетаданных.
Процедура ПриЗаполненииВидовОграниченийПравОбъектовМетаданных(Описание) Экспорт
	
	Описание = Описание + "
	|Справочник.АктПриемкиВыполненныхРаботОказанныхУслугПрисоединенныеФайлы.Чтение.ГруппыФизическихЛиц
	|Справочник.АктПриемкиВыполненныхРаботОказанныхУслугПрисоединенныеФайлы.Чтение.Организации
	|Справочник.АктПриемкиВыполненныхРаботОказанныхУслугПрисоединенныеФайлы.Изменение.ГруппыФизическихЛиц
	|Справочник.АктПриемкиВыполненныхРаботОказанныхУслугПрисоединенныеФайлы.Изменение.Организации
	|Справочник.ДоговорАвторскогоЗаказаПрисоединенныеФайлы.Чтение.ГруппыФизическихЛиц
	|Справочник.ДоговорАвторскогоЗаказаПрисоединенныеФайлы.Чтение.Организации
	|Справочник.ДоговорАвторскогоЗаказаПрисоединенныеФайлы.Изменение.ГруппыФизическихЛиц
	|Справочник.ДоговорАвторскогоЗаказаПрисоединенныеФайлы.Изменение.Организации
	|Справочник.ДоговорРаботыУслугиПрисоединенныеФайлы.Чтение.ГруппыФизическихЛиц
	|Справочник.ДоговорРаботыУслугиПрисоединенныеФайлы.Чтение.Организации
	|Справочник.ДоговорРаботыУслугиПрисоединенныеФайлы.Изменение.ГруппыФизическихЛиц
	|Справочник.ДоговорРаботыУслугиПрисоединенныеФайлы.Изменение.Организации
	|Документ.АктПриемкиВыполненныхРаботОказанныхУслуг.Чтение.ГруппыФизическихЛиц
	|Документ.АктПриемкиВыполненныхРаботОказанныхУслуг.Чтение.Организации
	|Документ.АктПриемкиВыполненныхРаботОказанныхУслуг.Изменение.ГруппыФизическихЛиц
	|Документ.АктПриемкиВыполненныхРаботОказанныхУслуг.Изменение.Организации
	|Документ.ДоговорАвторскогоЗаказа.Чтение.ГруппыФизическихЛиц
	|Документ.ДоговорАвторскогоЗаказа.Чтение.Организации
	|Документ.ДоговорАвторскогоЗаказа.Изменение.ГруппыФизическихЛиц
	|Документ.ДоговорАвторскогоЗаказа.Изменение.Организации
	|Документ.ДоговорРаботыУслуги.Чтение.ГруппыФизическихЛиц
	|Документ.ДоговорРаботыУслуги.Чтение.Организации
	|Документ.ДоговорРаботыУслуги.Изменение.ГруппыФизическихЛиц
	|Документ.ДоговорРаботыУслуги.Изменение.Организации
	|Документ.НачислениеПоДоговорам.Чтение.ГруппыФизическихЛиц
	|Документ.НачислениеПоДоговорам.Чтение.Организации
	|Документ.НачислениеПоДоговорам.Изменение.ГруппыФизическихЛиц
	|Документ.НачислениеПоДоговорам.Изменение.Организации
	|Справочник.НачислениеПоДоговорамПрисоединенныеФайлы.Чтение.ГруппыФизическихЛиц
	|Справочник.НачислениеПоДоговорамПрисоединенныеФайлы.Чтение.Организации
	|Справочник.НачислениеПоДоговорамПрисоединенныеФайлы.Изменение.ГруппыФизическихЛиц
	|Справочник.НачислениеПоДоговорамПрисоединенныеФайлы.Изменение.Организации
	|ЖурналДокументов.ДоговорыГражданскоПравовогоХарактера.Чтение.ГруппыФизическихЛиц
	|ЖурналДокументов.ДоговорыГражданскоПравовогоХарактера.Чтение.Организации";
	
КонецПроцедуры

#КонецОбласти

#Область ДатыЗапретаИзменения

// См. ДатыЗапретаИзмененияПереопределяемый.ЗаполнитьИсточникиДанныхДляПроверкиЗапретаИзменения.
Процедура ЗаполнитьИсточникиДанныхДляПроверкиЗапретаИзменения(ИсточникиДанных) Экспорт
	
	ДатыЗапретаИзменения.ДобавитьСтроку(
		ИсточникиДанных,
		"Документ.АктПриемкиВыполненныхРаботОказанныхУслуг",
		"МесяцНачисления",
		"Зарплата",
		"Организация");
	
	ДатыЗапретаИзменения.ДобавитьСтроку(
		ИсточникиДанных,
		"Документ.ДоговорРаботыУслуги",
		"ДатаНачала",
		"Зарплата",
		"Организация");
	
	ДатыЗапретаИзменения.ДобавитьСтроку(
		ИсточникиДанных,
		"Документ.ДоговорАвторскогоЗаказа",
		"ДатаНачала",
		"Зарплата",
		"Организация");
	
	ДатыЗапретаИзменения.ДобавитьСтроку(
		ИсточникиДанных,
		"Документ.НачислениеПоДоговорам",
		"МесяцНачисления",
		"Зарплата",
		"Организация");
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

